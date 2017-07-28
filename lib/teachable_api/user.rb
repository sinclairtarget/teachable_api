require_relative 'order'

# Represents a user or potential user of the mock Teachable API.
module Teachable
  class User
    attr_reader :id, :token, :created_at, :updated_at

    def initialize(email)
      raise_if_blank email, 'email'
      @email = email
      @token = nil
    end
    
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

    def refresh_from_user_response(resp)
      @id = resp.body['id']
      @token = resp.body['tokens']
      @created_at = resp.body['created_at']
      @updated_at = resp.body['updated_at']
      self
    end

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

class Object
  protected

  def raise_if_blank(str, name)
    raise ArgumentError, "#{name} cannot be blank" if str.nil? || str.empty?
  end
end
