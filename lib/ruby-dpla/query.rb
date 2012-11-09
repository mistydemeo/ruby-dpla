require 'ruby-dpla/exceptions'

require 'httparty'
require 'json'

module DPLA
  class Query
    include Enumerable
    include HTTParty
    base_uri 'http://api.dp.la/v1'
    attr_reader :parameters, :response, :page

    PARAMETERS = %w[
      title description creator type publisher format rights
      contributor created spatial temporal source id q
    ]

    def self.parameters_correct? params
      params.keys.all? {|key| PARAMETERS.include? key.to_s.split('.').first}
    end

    def initialize parameters
      @page = 1

      raise DPLA::ParameterError, "unrecognized parameter" unless Query.parameters_correct? parameters
      @parameters = parameters
      @parameters[:page_size] = 100

      json = self.class.get('items', :body => parameters).body
      @response = JSON.parse(json)
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

      json = self.class.get('items', :body => params).body
      @response = JSON.parse(json)
    end

    def results; @response['docs']; end
    def count; @response['count']; end
    def start; @response['start']; end
    def limit; @response['limit']; end
  end
end
