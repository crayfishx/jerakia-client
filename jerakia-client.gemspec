require 'rake'
require './lib/jerakia/client/version'

Gem::Specification.new do |s|
  s.name       = 'jerakia-client'
  s.version    = Jerakia::Client::VERSION
  s.date       = %x{ /bin/date '+%Y-%m-%d' }
  s.summary    = 'CLI and ruby client libraries for Jerakia Server'
  s.description    = 'CLI and ruby client libraries for Jerakia Server'
  s.authors     = [ 'Craig Dunn' ]
  s.files       = [ 'bin/jerakia-client', Rake::FileList["lib/**/*"].to_a ].flatten
  s.bindir      = 'bin'
  s.executables << 'jerakia-client'
  s.homepage    = 'http://jerakia.io'
  s.license     = 'Apache 2.0'
  s.add_dependency 'thor', '~> 0.19'
  s.add_dependency 'rest-client', '~> 1.8'
end
