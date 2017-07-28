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

    # =================================================================
    # User Refresh
    # =================================================================
    def test_can_refresh_authenticated_user
      user = User.new USER_CREDENTIALS[:email]
      
      VCR.use_cassette('sign_in') do
        user.authenticate! USER_CREDENTIALS[:password]
      end

      VCR.use_cassette('refresh') do
        user.refresh!
      end
    end

    def test_cannot_refresh_unauthenticated_user
      user = User.new USER_CREDENTIALS[:email]
      
      VCR.use_cassette('refresh_without_auth') do
        assert_raises AuthError do
          user.refresh!
        end
      end
    end

    # =================================================================
    # Registration
    # =================================================================
    def test_can_register_user
      VCR.use_cassette('registration') do
        u = User.register(
          email: USER_CREDENTIALS[:email],
          password: USER_CREDENTIALS[:password],
          password_confirmation: USER_CREDENTIALS[:password]
        )
        
        refute_nil u
        refute_nil u.token
      end
    end
    
    def test_must_provide_email
      VCR.use_cassette('registration') do
        assert_raises ArgumentError do
          User.register(
            password: USER_CREDENTIALS[:password],
            password_confirmation: USER_CREDENTIALS[:password]
          )
        end

        assert_raises ArgumentError do
          User.register(
            email: nil,
            password: USER_CREDENTIALS[:password],
            password_confirmation: USER_CREDENTIALS[:password]
          )
        end

        assert_raises ArgumentError do
          User.register(
            email: '',
            password: USER_CREDENTIALS[:password],
            password_confirmation: USER_CREDENTIALS[:password]
          )
        end
      end
    end

    def test_must_provide_password
      VCR.use_cassette('registration') do
        assert_raises ArgumentError do
          User.register(
            email: USER_CREDENTIALS[:email],
            password_confirmation: USER_CREDENTIALS[:password]
          )
        end

        assert_raises ArgumentError do
          User.register(
            email: USER_CREDENTIALS[:email],
            password: nil,
            password_confirmation: USER_CREDENTIALS[:password]
          )
        end

        assert_raises ArgumentError do
          User.register(
            email: USER_CREDENTIALS[:email],
            password: '',
            password_confirmation: USER_CREDENTIALS[:password]
          )
        end
      end
    end

    def test_must_provide_password_confirmation
      VCR.use_cassette('registration') do
        assert_raises ArgumentError do
          User.register(
            email: USER_CREDENTIALS[:email],
            password: USER_CREDENTIALS[:password]
          )
        end

        assert_raises ArgumentError do
          User.register(
            email: USER_CREDENTIALS[:email],
            password: USER_CREDENTIALS[:password],
            password_confirmation: nil
          )
        end

        assert_raises ArgumentError do
          User.register(
            email: USER_CREDENTIALS[:email],
            password: USER_CREDENTIALS[:password],
            password_confirmation: ''
          )
        end
      end
    end

    def test_bad_confirmation_raises_error
      VCR.use_cassette('registration_bad_confirmation') do
        assert_raises ValidationError do
          User.register(
            email: USER_CREDENTIALS[:email],
            password: USER_CREDENTIALS[:password],
            password_confirmation: USER_CREDENTIALS[:password]
          )
        end
      end
    end

    def test_bad_email_raises_error
      VCR.use_cassette('registration_bad_email') do
        assert_raises ValidationError do
          User.register(
            email: 'notanemail',
            password: USER_CREDENTIALS[:password],
            password_confirmation: USER_CREDENTIALS[:password]
          )
        end
      end
    end
  end
end
