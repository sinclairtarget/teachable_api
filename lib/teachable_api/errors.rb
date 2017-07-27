module Teachable
  class Error < StandardError; end

  # Typically raised in response to a 401. The user's email or password may not
  # be correct.
  class AuthError < Error; end
end
