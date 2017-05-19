require 'yaml'
class Jerakia
  class Client
    class Token
      class << self
        def load_from_file
          [
            File.join(ENV['HOME'] || '', ".jerakia", "jerakia.yaml"),
            "/etc/jerakia/jerakia.yaml",
          ]. each do |file|
            if File.exists?(file)
              config = YAML.load(File.read(file))
              return config['client_token'] if config['client_token']
            end
          end
          return nil
        end
      end
    end
  end
end
