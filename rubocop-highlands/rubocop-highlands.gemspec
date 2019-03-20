$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'rubocop/highlands/version'

Gem::Specification.new do |spec|
  spec.name = 'rubocop-highlands'
  spec.summary = 'Custom code style checking for Church of the Highlands.'
  spec.description = <<-EOF
    A plugin for RuboCop code style enforcing & linting tool. It includes Rubocop configuration
    used at Church of the Highlands and a few custom rules that have cause internal issues at
    Church of the Highlands but are not supported by core Rubocop.
  EOF
  spec.authors = ['Church of the Highlands - Digital Team']
  spec.email = ['info@churchofthehighlands.com']
  spec.homepage = 'https://github.com/highlands/ruby'
  spec.license = 'MIT'
  spec.version = RuboCop::Highlands::VERSION
  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.1'

  spec.require_paths = ['lib']
  spec.files = Dir[
    '{config,lib,spec}/**/*',
    '*.md',
    '*.gemspec',
    'Gemfile',
  ]

  spec.add_dependency('rubocop', '~> 0.58.0')
  spec.add_dependency('rubocop-rspec', '~> 1.30.0')
  spec.add_development_dependency('rspec', '~> 3.5')
end
