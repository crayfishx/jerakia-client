require 'json'
require 'yaml'

class Jerakia
  class Client
    class CLI < Thor
      module Lookup
        def self.included(thor)
          thor.class_eval do
            desc 'lookup [KEY]', 'Lookup [KEY] with Jerakia'

            option :host,
              aliases: :H,
              type: :string,
              default: nil,
              desc: 'Hostname or IP to connect to'

            option :port,
              aliases: :P,
              type: :string,
              default: nil,
              desc: 'Port to connect to'

            option :token,
              aliases: :T,
              type: :string,
              default: nil,
              desc: "Token to use for authorization, if not provided a jerakia.yaml will be searched for (see docs)"

            option :api,
              aliases: :a,
              type: :string,
              default: nil,
              desc: 'API Version to implement (see docs)'

            option :policy,
                   aliases: :p,
                   type: :string,
                   default: 'default',
                   desc: 'Lookup policy'
            option :namespace,
                   aliases: :n,
                   type: :string,
                   default: '',
                   desc: 'Lookup namespace'
            option :type,
                   aliases: :t,
                   type: :string,
                   default: 'first',
                   desc: 'Lookup type'
            option :metadata,
                   aliases: :m,
                   type: :hash,
                   default: {},
                   desc: 'Metadata to send with the request'
            option :scope,
                   aliases: :s,
                   type: :string,
                   desc: 'Scope handler',
                   default: 'metadata'
            option :scope_options,
                   type: :hash,
                   default: {},
                   desc: 'Key/value pairs to be passed to the scope handler'
            option :merge_type,
                   aliases: :m,
                   type: :string,
                   default: 'array',
                   desc: 'Merge type'
            option :verbose,
                   aliases: :v,
                   type: :boolean,
                   desc: 'Print verbose information'
            option :debug,
                   aliases: :D,
                   type: :boolean,
                   desc: 'Debug information to console, implies --log-level debug'

            option :output,
                   aliases: :o,
                   type: :string,
                   default: 'json',
                   desc: 'Output format, yaml or json'

            def lookup(key)
              client = Jerakia::Client.new({
                :host  => options[:host],
                :port  => options[:port],
                :api   => options[:api],
                :token => options[:token],
              })

              lookup_opts = {
                :namespace     => options[:namespace].split(/::/),
                :policy        => options[:policy].to_sym,
                :lookup_type   => options[:type].to_sym,
                :merge         => options[:merge_type].to_sym,
                :scope         => options[:scope].to_sym,
                :use_schema    => options[:schema]
              }

              if options[:metadata]
                options[:metadata].each do |k,v|
                  lookup_opts["metadata_#{k}".to_sym] = v
                end
              end

              if options[:scope]
                options[:scope_options].each do |k,v|
                  lookup_opts["scope_#{k}".to_sym] = v
                end
              end

              response = client.lookup(key, lookup_opts)
              answer = response['payload']
              case options[:output]
              when 'json'
                puts answer.to_json
              when 'yaml'
                puts answer.to_yaml
              else
                raise Jerakia::Client::Error, "Unknown output type #{options[:output]}"
              end
            end
          end
        end
      end
    end
  end
end
