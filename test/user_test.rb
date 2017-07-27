require 'test_helper'

module Teachable
  class UserTest < Minitest::Test
    USER_CREDENTIALS = {
      email: 'sinclair_test_user@test.com',
      password: 'password'
    }.freeze

    def test_user_can_init
      user = User.new USER_CREDENTIALS[:email]
      refute_nil user
    end

    def test_user_cannot_init_without_email
      assert_raises ArgumentError do
        User.new
      end

      assert_raises ArgumentError do
        User.new nil
      end

      assert_raises ArgumentError do
        User.new ''
      end
    end

    # =================================================================
    # Authentication
    # =================================================================
    def test_authenticate_requires_password
      assert_raises ArgumentError do
        User.new(USER_CREDENTIALS[:email]).authenticate!
      end

      assert_raises ArgumentError do
        User.new(USER_CREDENTIALS[:email]).authenticate! nil
      end

      assert_raises ArgumentError do
        User.new(USER_CREDENTIALS[:email]).authenticate! ''
      end
    end

    def test_can_authenticate
      user = User.new USER_CREDENTIALS[:email]
      
      VCR.use_cassette('sign_in') do
        user.authenticate! USER_CREDENTIALS[:password]
      end

      refute_nil user.token
    end

    def test_incorrect_email_raises_auth_error
      user = User.new 'sinclair_foo@bar.com'

      VCR.use_cassette('sign_in_bad_email') do
        assert_raises Teachable::AuthError do
          user.authenticate! USER_CREDENTIALS[:password]
        end
      end
    end

    def test_incorrect_password_raises_auth_error
      user = User.new USER_CREDENTIALS[:email]
      
      VCR.use_cassette('sign_in_bad_password') do
        assert_raises Teachable::AuthError do
          user.authenticate! 'foo'
        end
      end
    end
  end
end
