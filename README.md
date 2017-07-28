### Teachable Mock API Client
This is a simple Ruby interface to the Teachable Mock API. Using this gem you
can interact with the API in an object-oriented manner:

```
# Register a user:
$ irb(main):001:0> user = Teachable::User.register(email: 'sinclair_demo@test.com', password: 'password', password_confirmation: 'password') 
=> #<Teachable::User:0x007fd36f9d0e00 @email="sinclair_demo@test.com", @token="DJQcbgKCroKcS87wBnct", @id=319, @created_at="2017-07-28T19:04:45.400Z", @updated_at="2017-07-28T19:04:45.418Z">

# Sign in an existing user:
$ irb(main):008:0> user = Teachable::User.new 'sinclair_demo@test.com'
=> #<Teachable::User:0x007fd36f8a2a10 @email="sinclair_demo@test.com", @token=nil>
$ irb(main):010:0> user.authenticate! 'password'
=> #<Teachable::User:0x007fd36f8a2a10 @email="sinclair_demo@test.com", @token="DJQcbgKCroKcS87wBnct", @id=319, @created_at="2017-07-28T19:04:45.400Z", @updated_at="2017-07-28T19:06:47.796Z">
```
