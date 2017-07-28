### Teachable Mock API Client
This is a simple Ruby interface to the Teachable Mock API. Using this gem you
can interact with the API in an object-oriented manner.

You can register a user:
```
$ irb(main):001:0> user = Teachable::User.register(email: 'sinclair_demo@test.com', password: 'password', password_confirmation: 'password') 
=> #<Teachable::User:0x007fd36f9d0e00 @email="sinclair_demo@test.com", @token="DJQcbgKCroKcS87wBnct", @id=319, @created_at="2017-07-28T19:04:45.400Z", @updated_at="2017-07-28T19:04:45.418Z">
```

You can sign in an existing user:
```
$ irb(main):008:0> user = Teachable::User.new 'sinclair_demo@test.com'
=> #<Teachable::User:0x007fd36f8a2a10 @email="sinclair_demo@test.com", @token=nil>
$ irb(main):010:0> user.authenticate! 'password'
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
