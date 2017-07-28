require_relative 'order'
require_relative 'util'

module Teachable
  # Represents a user or potential user of the mock Teachable API.
  class User
    include Util
    extend Util

    attr_reader :id, :token, :created_at, :updated_at

    # Initializes a user identified by the given email.
    #
    # An initialized user starts off unauthenticated. You must call
    # #authenticate! before making any method calls that require
    # authentication.
    def initialize(email)
      raise_if_blank email, 'email'
      @email = email
      @token = nil
    end
    
    # Authenticates the current user with the service, obtaining a user token.
    def authenticate!(password)
      raise_if_blank password, 'password'
      resp = API.connection.post 'users/sign_in', { 
        user: {
          email: @email, 
          password: password
        }
      }

      case resp.status
      when 201
        refresh_from_user_response resp
      when 401
        raise Teachable::AuthError, resp.body['error']
      else
        raise Teachable::Error, 'Unknown response.'
      end
    end

    # Asks the service for the latest information about this user. Updates the
    # stored user token.
    #
    # Requires authentication.
    def refresh!
      resp = API.connection.get 'api/users/current_user/edit', {
        user_email: @email,
        user_token: @token
      }

      case resp.status
      when 200
        refresh_from_user_response resp
      when 401
        raise Teachable::AuthError, resp.body['error']
      else
        raise Teachable::Error, 'Unknown response.'
      end
    end

    # Lists all the orders currently associated with this user.
    #
    # Requires authentication.
    #
    # NOTE: The results are not cached, so each call to this method will 
    # involve a network request.
    def orders
      resp = API.connection.get 'api/orders', {
        user_email: @email,
        user_token: @token
      }

      case resp.status
      when 200
        resp.body.map { |order_hash| Order.new(order_hash) }
      when 401
        raise Teachable::AuthError, resp.body['error']
      else
        raise Teachable::Error, 'Unknown response.'
      end
    end

    # Creates an order associated with this user.
    #
    # Requires authentication.
    def add_order(total:, total_quantity:, special_instructions: nil)
      resp = API.connection.post 'api/orders', {
        order: {
          total: total,
          total_quantity: total_quantity,
          special_instructions: special_instructions,
          email: @email
        }
      } do |req|
        req.params[:user_email] = @email
        req.params[:user_token] = @token
      end

      case resp.status
      when 200 # Why isn't this a 201?
        Order.new resp.body
      when 401
        raise Teachable::AuthError, resp.body['error']
      when 422
        messages = resp.body['errors'].map do |error|
          error['title']
        end
        message = messages.join(', ')
        raise Teachable::ValidationError, message
      else
        raise Teachable::Error, 'Unknown response.'
      end
    end

    # Destroys the given order so that it is no longer associated with this
    # user.
    #
    # Requires authentication.
    def remove_order(order)
      resp = API.connection.delete "api/orders/#{order.id}", {
        user_email: @email,
        user_token: @token
      }

      case resp.status
      when 204
        order
      when 401
        raise Teachable::AuthError, resp.body['error']
      when 404
        nil
      else
        raise Teachable::Error, 'Unknown response.'
      end
    end

    # :nodoc:
    def refresh_from_user_response(resp)
      @id = resp.body['id']
      @token = resp.body['tokens']
      @created_at = resp.body['created_at']
      @updated_at = resp.body['updated_at']
      self
    end

    # Registers a new user with the service.
    #
    # Returns a new user object that is already authenticated.
    def self.register(email:, password:, password_confirmation:)
      raise_if_blank email, 'email'
      raise_if_blank password, 'password'
      raise_if_blank password_confirmation, 'password_confirmation'

      resp = API.connection.post 'users', {
        user: {
          email: email,
          password: password,
          password_confirmation: password_confirmation
        }
      }
      case resp.status
      when 201
        user = User.new email
        user.refresh_from_user_response resp
      when 422
        messages = resp.body['errors'].map do |field, msgs|
          "#{field} #{msgs.join(', ')}"
        end
        message = messages.join('; ')
        raise Teachable::ValidationError, message
      else
        raise Teachable::Error, 'Unknown response.'
      end
    end
  end
end
