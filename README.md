# ruby-dpla

This is a very simple, fairly bare-bones gem allowing access to the DPLA API.

## Installation

Right now:

rake build
gem install pkg/ruby-dpla-0.0.1.gem

Eventually it'll be uploaded to rubygems.

## Usage

You can create a query object using a parameter hash:

```ruby
DPLA::Query.new :title => 'fruit'
```

The actual records themselves are accessible via the `#results` instance method, which returns an array of results. At the moment, those are returned in pages of 100. To access the next page, use the `#next_page` instance method, or `#fetch_page` to fetch an arbitrary page. You can also `#rewind` to go back to the first page.

In addition, the query object is enumerable:

```ruby
query = DPLA::Query.new :title => 'fruit'
query.each do |results|
  ...
end
```

The `results` object yielded is the current array of objects.

Probably there are missing features and gotchas, so let me know when you find them (or what you want)!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
