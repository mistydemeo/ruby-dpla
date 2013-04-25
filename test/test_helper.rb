
require 'rubygems'
require 'bundler/setup'

require 'simplecov'
SimpleCov.start


require 'minitest/autorun'
require 'webmock/test_unit'
require 'ruby-dpla/query'
require 'ruby-dpla/parameters'

ENV["DPLA_API_KEY"] = "MYDPLAAPIKEY"



require 'shoulda'
require 'turn/autorun' unless ENV["TM_FILEPATH"]
require 'mocha/setup'


class Test::Unit::TestCase
  
  def request_params(params)
    { :api_key => ENV["DPLA_API_KEY"]  }.update(params)
  end
  
  def fixtures_path
    Pathname( File.expand_path( 'fixtures', File.dirname(__FILE__) ) )
  end

  def fixture_file(path)
    File.read File.expand_path( path, fixtures_path )
  end

end