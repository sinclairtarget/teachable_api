module Teachable
  class Error < StandardError; end

  # Typically raised in response to a 401. The user's email or password may not
  # be correct.
  class AuthError < Error; end

  # Typically raised in response to a 422. Data submitted to the server did not
  # make sense.
  class ValidationError < Error; end
end
