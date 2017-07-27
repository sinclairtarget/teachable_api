require 'test_helper'

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
end
