$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'rubocop/airbnb/version'

Gem::Specification.new do |spec|
  spec.name = 'rubocop-airbnb'
  spec.summary = 'Custom code style checking for Airbnb.'
  spec.description = <<-EOF
    A plugin for RuboCop code style enforcing & linting tool. It includes Rubocop configuration
    used at Airbnb and a few custom rules that have cause internal issues at Airbnb but are not
    supported by core Rubocop.
  EOF
  spec.authors = ['Airbnb Engineering']
  spec.email = ['rubocop@airbnb.com']
  spec.homepage = 'https://github.com/airbnb/ruby'
  spec.license = 'MIT'
  spec.version = RuboCop::Airbnb::VERSION
  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.5'

  spec.require_paths = ['lib']
  spec.files = Dir[
    '{config,lib,spec}/**/*',
    '*.md',
    '*.gemspec',
    'Gemfile',
  ]

  # rubocop:disable Layout/LineLength
  spec.add_dependency('rubocop', '>= 1.22.0', '< 1.32', '!= 1.29.0', '!= 1.29.1', '!= 1.30.0', '!= 1.30.1')
  # rubocop:enable Layout/LineLength

  spec.add_dependency('rubocop-performance', '~> 1.10.2')
  spec.add_dependency('rubocop-rails', '~> 2.9.1')
  spec.add_dependency('rubocop-rspec', '~> 2.0.0')
  spec.add_development_dependency('rspec', '~> 3.5')
end
