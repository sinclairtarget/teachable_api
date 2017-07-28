### Teachable Mock API Client
This is a simple Ruby interface to the Teachable Mock API. Using this gem you
can interact with the API in an object-oriented manner.

You can register a user:
```
irb(main):001:0> user = Teachable::User.register(email: 'sinclair_demo@test.com', password: 'password', password_confirmation: 'password') 
=> #<Teachable::User:0x007fd36f9d0e00 @email="sinclair_demo@test.com", @token="DJQcbgKCroKcS87wBnct", @id=319, @created_at="2017-07-28T19:04:45.400Z", @updated_at="2017-07-28T19:04:45.418Z">
```

You can sign in an existing user:
```
irb(main):008:0> user = Teachable::User.new 'sinclair_demo@test.com'
=> #<Teachable::User:0x007fd36f8a2a10 @email="sinclair_demo@test.com", @token=nil>
irb(main):010:0> user.authenticate! 'password'
=> #<Teachable::User:0x007fd36f8a2a10 @email="sinclair_demo@test.com", @token="DJQcbgKCroKcS87wBnct", @id=319, @created_at="2017-07-28T19:04:45.400Z", @updated_at="2017-07-28T19:06:47.796Z">
```

And you can manipulate a user's orders:
```
irb(main):002:0> user.orders
=> []
irb(main):003:0> order = user.add_order(total: '5.0', total_quantity: 5, special_instructions: 'foo bar')
=> #<Teachable::Order:0x007fd36f9917c8 @id=488, @number="a0509e9ae7b0d67c", @special_instructions="foo bar", @total="5.0", @total_quantity=5, @created_at="2017-07-28T19:05:39.011Z", @updated_at="2017-07-28T19:05:39.011Z">
irb(main):004:0> user.orders
=> [#<Teachable::Order:0x007fd36f9784a8 @id=488, @number="a0509e9ae7b0d67c", @special_instructions="foo bar", @total="5.0", @total_quantity=5, @created_at="2017-07-28T19:05:39.011Z", @updated_at="2017-07-28T19:05:39.011Z">]
irb(main):006:0> user.remove_order(order)
=> #<Teachable::Order:0x007fd36f95a728 @id=488, @number="a0509e9ae7b0d67c", @special_instructions="foo bar", @total="5.0", @total_quantity=5, @created_at="2017-07-28T19:05:39.011Z", @updated_at="2017-07-28T19:05:39.011Z">
irb(main):007:0> user.orders
=> []
```

#### Configuring the Connection
This Ruby client library depends on the
[Faraday](https://github.com/lostisland/faraday) gem for making HTTP requests.
Faraday is highly configurable. The Faraday connection object used to make
requests can be replaced if needed, perhaps to tweak timeouts or to change the
base API URL:
```
irb(main):007:0> Teachable::API.connection = Faraday.new 'http://foobar.com', request: { timeout: 2 } do |conn|
irb(main):008:1* conn.request :json
irb(main):009:1> conn.response :json
irb(main):010:1> conn.adapter Faraday.default_adapter
irb(main):011:1> conn.headers['Accept'] = 'application/json'
irb(main):012:1> end
=> #<Faraday::Connection:0x007ff0b919a670 @parallel_manager=nil, @headers={"Accept"=>"application/json", "User-Agent"=>"Faraday v0.12.2"}, @params={}, @options=#<Faraday::RequestOptions timeout=2>, @ssl=#<Faraday::SSLOptions (empty)>, @default_parallel_manager=nil, @builder=#<Faraday::RackBuilder:0x007ff0b919a328 @handlers=[FaradayMiddleware::EncodeJson, FaradayMiddleware::ParseJson, Faraday::Adapter::NetHttp]>, @url_prefix=#<URI::HTTP http://foobar.com/>, @proxy=nil>
```

#### Building the Gem
The gem is not available on rubygems.org but can be built and installed using
the `gem` utility:
```
$ gem build teachable_api.gemspec
  Successfully built RubyGem
  Name: teachable_api
  Version: 0.0.1
  File: teachable_api-0.0.1.gem
$ gem install teachable_api-0.0.1.gem
Successfully installed teachable_api-0.0.1
Parsing documentation for teachable_api-0.0.1
Done installing documentation for teachable_api after 0 seconds
1 gem installed
```
