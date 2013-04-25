require 'test_helper'



module DPLA

  class QueryTest < Test::Unit::TestCase

    context "DPLA::Query" do
      
      should "be able to create a query from a parameter hash" do
        params = request_params ( { :"sourceResource.title" => 'Receipt issued by Cecil R. Sovey' } )
        stub_request(:get, "http://api.dp.la/v2/items").
                    with(:query => params).
                    to_return(:status => 200, :body => "{}", :headers => {})
              
        query = DPLA::Query.new params
        assert query
        
        params = request_params( { :title => 'Receipt issued by Cecil R. Sovey' } )
        query = DPLA::Query.new params
        assert query
      end

      should "return the items as an array of hashes" do
    
        params = request_params({
          :"sourceResource.title" => 'Receipt issued by Cecil R. Sovey'
        })
        stub_request(:get, "http://api.dp.la/v2/items").
                      with(:query => params).
                      to_return(:status => 200, :body => fixture_file("results-1.json"), :headers => {})
        
        query = DPLA::Query.new params
        query.results.must_be_kind_of Array
        query.results.first.must_be_kind_of Hash
      end

      should "raise if created with an incorrect parameter" do
        params = { :foo => 'bar' }
        lambda {DPLA::Query.new params}.must_raise DPLA::ParameterError
      end

      should "be able to fetch multiple pages of results" do
        params = request_params ( { :q => 'washington' } ) 
        stub_request(:get, "http://api.dp.la/v2/items").with(:query => params).
                        to_return(:status => 200, :body => fixture_file("results-1.json"), :headers => {})
        query = DPLA::Query.new params
        first_result = query.results.first
        
        stub_request(:get, "http://api.dp.la/v2/items").with(:query => params.update(:page => 2 )).
                   to_return(:status => 200, :body => fixture_file("results-2.json"), :headers => {}) 
        query.next_page
        query.results.first.wont_equal first_result
        
        stub_request(:get, "http://api.dp.la/v2/items").with(:query => params.update(:page => 1 )).
                        to_return(:status => 200, :body => fixture_file("results-1.json"), :headers => {})
        
        query.rewind
        assert query
      end

      should "be enumerable" do
        params =  request_params ({
          :q => 'burger king'
        })

        stub_request(:get, "http://api.dp.la/v2/items?api_key=MYDPLAAPIKEY&q=burger%20king").
                   to_return(:status => 200, :body =>  fixture_file("results-1.json"), :headers => {})

        query = DPLA::Query.new params
        query.must_respond_to :each
        query.must_respond_to :map

        results = query.results
        query.each.first.must_equal results


        stub_request(:get, "http://api.dp.la/v2/items?api_key=MYDPLAAPIKEY&page=1&q=burger%20king").
                     to_return(:status => 200, :body =>  "{}", :headers => {})
        query.rewind
        
        stub_request(:get, "http://api.dp.la/v2/items?api_key=MYDPLAAPIKEY&page=2&q=burger%20king").
                       to_return(:status => 200, :body =>  fixture_file("results-2.json"), :headers => {})
        query.next_page
        results = query.results
        enum = query.each
        enum.next
        enum.next.must_equal results
      end

      should "raise when requested to fetch a page using a non-int" do
        params = request_params( {:q => 'washington'} )
         stub_request(:get, "http://api.dp.la/v2/items").
                      with(:query => params).
                      to_return(:status => 200, :body => "{}", :headers => {})
        query = DPLA::Query.new params
        lambda {query.fetch_page 'foo'}.must_raise DPLA::ParameterError
      end
      
      should "return a url for debugging" do
          params = request_params( {:q => 'washington'} )
           stub_request(:get, "http://api.dp.la/v2/items").
                        with(:query => params).
                        to_return(:status => 200, :body => "{}", :headers => {})
          query = DPLA::Query.new params
          assert_equal query.url, "http://api.dp.la/v2/items?api_key=MYDPLAAPIKEY&q=washington" 
     end
     
     context "Facets" do
       
       should "request facets in a param and have those facets accessible" do
         params = request_params( { :facets  => ['sourceResource.spatial.coordinates:42.3:-71:20mi', 'sourceResource.spatial.state'] })
         stub_request(:get,
          "http://api.dp.la/v2/items?api_key=MYDPLAAPIKEY&facets=sourceResource.spatial.coordinates:42.3:-71:20mi,sourceResource.spatial.state")
                       .to_return(:status => 200, :body => fixture_file("results-facets.json"), :headers => {})
         query = DPLA::Query.new params
         assert_equal query.facets.keys, ["sourceResource.spatial.coordinates", "sourceResource.spatial.state"]
                        
                       
       end
     
     end
    end
  end
end