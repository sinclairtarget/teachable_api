# Represents a user or potential user of the mock Teachable API.
class User
  def initialize(email)
    raise ArgumentError, 'email cannot be blank' if email.nil? || email.empty?
    @email = email
  end
end
