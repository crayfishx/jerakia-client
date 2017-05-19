require 'jerakia/client/error'
require 'jerakia/client/version'
require 'jerakia/client/lookup'
require 'jerakia/client/scope'
require 'jerakia/client/token'
require 'uri'
require 'json'
require 'net/http'

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
        File.join(ENV['HOME'] || '', '.jerakia', 'jerakia.yaml'),
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
      jerakia_token = ENV['JERAKIA_TOKEN'] || @config[:token]
      @token ||= jerakia_token
      raise Jerakia::Client::Error, "No authorization token available" if @token.nil?
      @token
    end

    def url_address
      "#{@config[:proto]}://#{@config[:host]}:#{@config[:port]}"
    end

    def http_send(request)
      request.add_field("X-Authentication",  token)
      response = Net::HTTP.new(@config[:host], @config[:port]).start do |http|
        http.request(request)
      end

      case response.code
      when "200"
        return JSON.parse(response.body)
      when "401"
        raise Jerakia::Client::AuthorizationError, "Request not authorized"
      when "501"
        raise Jerakia::Client::ScopeNotFoundError, "Scope data not found" if response.body =~ /No scope data found/
        raise Jerakia::Client::Error, response.body
      else
        raise Jerakia::Client::Error, response.body
      end
    end


    def get(url_path, params={})
      uri = URI.parse(url_address +  url_path)
      uri.query = URI.encode_www_form(params)
      request = Net::HTTP::Get.new(uri.to_s)
      return http_send(request)
    end

    def put(url_path, params)
      uri = URI.parse(url_address + url_path)
      request = Net::HTTP::Put.new(uri.path)
      request.add_field('Content-Type', 'application/json')
      request.body = params.to_json
      return http_send(request)
    end
  end
end


