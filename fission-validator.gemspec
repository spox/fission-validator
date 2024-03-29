$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__)) + '/lib/'
require 'fission-validator/version'
Gem::Specification.new do |s|
  s.name = 'fission-validator'
  s.version = Fission::Validator::VERSION.version
  s.summary = 'Fission Validator'
  s.author = 'Heavywater'
  s.email = 'fission@hw-ops.com'
  s.homepage = 'http://github.com/heavywater/fission-validator'
  s.description = 'Fission Validator'
  s.require_path = 'lib'
  s.add_dependency 'fission', '>= 0.2.4', '< 1.0.0'
  s.files = Dir['{lib}/**/**/*'] + %w(fission-validator.gemspec README.md CHANGELOG.md)
end
