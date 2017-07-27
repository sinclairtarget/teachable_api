# Represents a user or potential user of the mock Teachable API.
module Teachable
  class User
    attr_reader :token

    def initialize(email)
      raise_if_blank email, 'email'
      @email = email
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

    protected 

    def raise_if_blank(str, name)
      raise ArgumentError, "#{name} cannot be blank" if str.nil? || str.empty?
    end

    def refresh_from_user_response(resp)
      @id = resp.body['id']
      @token = resp.body['tokens']
      @created_at = resp.body['created_at']
      @updated_at = resp.body['updated_at']
    end
  end
end
