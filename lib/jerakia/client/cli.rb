require 'thor'
require 'jerakia/client'
require 'jerakia/client/cli/lookup'

class Jerakia
  class Client
    class CLI < Thor
      include Jerakia::Client::CLI::Lookup

      desc 'version', 'Version information'
      def version
        puts Jerakia::Client::VERSION
      end

    end
  end
end
