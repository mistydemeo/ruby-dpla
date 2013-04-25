require 'ruby-dpla/exceptions'
require 'ruby-dpla/parameters'
require 'active_support/core_ext/hash/except'
require 'active_support/core_ext/object/to_query'
require 'active_support/json'


require 'httparty'
require 'json'

module DPLA
  class Query
    include Enumerable
    include HTTParty
    include DPLA::Parameters
    base_uri 'http://api.dp.la/v2'
    attr_reader :parameters, :response, :page

    def self.format_parameters params
      formatted_params = {}
      params.inject(formatted_params) do |h, (k,v)|
        if PARAMETERS.include? k.to_s.split('.').first
          h[k] = Array.wrap(v).join(",")
        elsif PARAMETERS.include? "sourceResource.#{k}"
          h["sourceResource.#{k}"] = Array.wrap(v).join(",")
        else
          raise DPLA::ParameterError, "unrecognized parameter"
        end
        h
      end
      formatted_params
    end

    def initialize parameters
      parameters[:api_key] ||= ENV["DPLA_API_KEY"]
      raise DPLA::ParameterError, "please provide a vaild DPLA API key" unless parameters[:api_key]
      
      @parameters = parameters.except(:page, :page_size)
      parameters = self.class.format_parameters(parameters) 
      @page = parameters[:page] ? parameters[:page].to_i : 1
      json = self.class.get('/items', :query => parameters).body
      @response = JSON.parse(json)
    end

    def url
      "#{DPLA::Query.base_uri}/items?#{ @parameters.to_query }"
    end

    def each
      return to_enum unless block_given?

      clone = dup
      clone.rewind unless clone.page == 1

      begin
        yield clone.results
        clone.next_page
      end while not clone.results.empty?
    end

    def next_page
      @page += 1
      fetch_page @page
    end

    def rewind
      @page = 1
      fetch_page @page
    end

    def fetch_page number
      raise DPLA::ParameterError, "page number must be a Fixnum" unless number.is_a? Fixnum

      @page = number
      params = @parameters.dup
      params[:page] = @page

      json = self.class.get('/items', :query => params).body
      @response = JSON.parse(json)
    end

    def results; @response['docs']; end
    def facets; @response["facets"]; end
    def count; @response['count']; end
    def start; @response['start']; end
    def limit; @response['limit']; end
  end
end
