require 'rest-client'
require 'jerakia/client/error'
require 'jerakia/client/version'
require 'jerakia/client/lookup'
require 'jerakia/client/scope'
require 'jerakia/client/token'
require 'uri'
require 'json'

class Jerakia
  class Client
    include Jerakia::Client::Lookup
    include Jerakia::Client::Scope

    attr_reader :config
    def initialize(opts={})
      @config = default_config.merge(
        opts.reject { |k,v| v.nil? }
      )
      @token = nil
    end

    def default_config 
      {
      :host => 'localhost',
      :port => 9843,
      :api  => 'v1',
      :proto => 'http',
      }
    end

    def default_lookup_options
      {
        :policy => :default,
        :lookup_type => :first,
      }
    end

    def token
      @token ||= @config[:token] 
      @token ||= Jerakia::Client::Token.load_from_file
      raise Jerakia::Client::Error, "No authorization token available" if @token.nil?
      @token
    end

    def url_address
      "#{@config[:proto]}://#{@config[:host]}:#{@config[:port]}"
    end


    def get(url_path, params={})
      headers = { 'X-Authentication' => token }
      uri_params = '?' + URI.encode_www_form(params)
      url = url_address + url_path + uri_params
      begin
        response = RestClient.get(url, headers)

      rescue RestClient::Unauthorized => e
        raise Jerakia::Client::AuthorizationError, "Request not authorized"
      rescue RestClient::Exception => e
        raise Jerakia::Client::Error, e.response.body
      end
      return JSON.parse(response.body)
    end

    def put(url_path, params)
      headers = { 
        'X-Authentication' => token,
        :content_type => :json
      }
      url = url_address + url_path
      begin
        response = RestClient.put(url, params.to_json, headers)
      rescue RestClient::Unauthorized => e
        raise Jerakia::Client::AuthorizationError, "Request not authorized"
      end
      return JSON.parse(response.body)
    end
  end
end


