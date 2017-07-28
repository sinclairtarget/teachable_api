require 'faraday'
require 'faraday_middleware'

module Teachable
  # The API class can be used to access or even replace the Faraday connection
  # used for making HTTP requests.
  class API
    DEFAULT_BASE = 'https://fast-bayou-75985.herokuapp.com/'.freeze

    class << self
      attr_accessor :connection
    end
  end
  
  API.connection = Faraday.new API::DEFAULT_BASE do |conn|
    conn.request :json
    conn.response :json
    conn.adapter Faraday.default_adapter

    conn.headers['Accept'] = 'application/json'
  end
end
