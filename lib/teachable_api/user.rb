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

    protected 

    def raise_if_blank(str, name)
      raise ArgumentError, "#{name} cannot be blank" if str.nil? || str.empty?
    end

    def refresh_from_user_response(resp)
      @id = resp.body['id']
      @token = resp.body['tokens']
      @created_at = resp.body['created_at']
      @updated_at = resp.body['updated_at']
      self
    end
  end
end
