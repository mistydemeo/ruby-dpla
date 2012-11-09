require 'minitest/autorun'
require 'ruby-dpla/query'

describe DPLA::Query do
  it "should be able to create a query from a parameter hash" do
    params = {
      :title => 'Receipt issued by Cecil R. Sovey'
    }
    query = DPLA::Query.new params
    assert query
  end

  it "should return the items as an array of hashes" do
    params = {
      :title => 'Receipt issued by Cecil R. Sovey'
    }
    query = DPLA::Query.new params
    query.results.must_be_kind_of Array
    query.results.first.must_be_kind_of Hash
  end

  it "should raise if created with an incorrect parameter" do
    params = {
      :foo => 'bar'
    }
    lambda {DPLA::Query.new params}.must_raise DPLA::ParameterError
  end

  it "should be able to fetch multiple pages of results" do
    params = {
      :q => 'washington'
    }

    query = DPLA::Query.new params
    first_result = query.results.first
    query.next_page
    query.results.first.wont_equal first_result
    query.rewind
    query.results.first.must_equal first_result
  end

  it "should be enumerable" do
    params = {
      :q => 'washington'
    }

    query = DPLA::Query.new params
    query.must_respond_to :each
    query.must_respond_to :map

    results = query.results
    query.each.first.must_equal results

    query.rewind
    query.next_page
    results = query.results
    enum = query.each
    enum.next
    enum.next.must_equal results
  end

  it "should raise when requested to fetch a page using a non-int" do
    query = DPLA::Query.new :q => 'washington'
    lambda {query.fetch_page 'foo'}.must_raise DPLA::ParameterError
  end
end
