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
      config_file_opts = self.class.load_config_from_file
      @config = default_config.merge(
        config_file_opts.merge(
          opts.reject { |k,v| v.nil? }
        )
      )
      @token = nil
    end

    def self.config_file
      [
        File.join(ENV['HOME'], '.jerakia', 'jerakia.yaml'),
        '/etc/jerakia/jerakia.yaml'
      ]. each do |filename|
        return filename if File.exists?(filename)
      end
      return nil
    end

    def self.load_config_from_file
      filename = config_file
      confighash = {}
      return {} unless filename
      configdata = YAML.load(File.read(filename))
      if configdata['client'].is_a?(Hash)
        configdata['client'].each do |k, v|
          confighash[k.to_sym] = v
        end
        return confighash
      end
      return {}
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
      rescue RestClient::NotFound => e
        return nil
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


