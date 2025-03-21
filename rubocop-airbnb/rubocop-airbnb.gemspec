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
  spec.required_ruby_version = '>= 2.7'

  spec.require_paths = ['lib']
  spec.files = Dir[
    '{config,lib,spec}/**/*',
    '*.md',
    '*.gemspec',
    'Gemfile',
  ]

  spec.metadata['default_lint_roller_plugin'] = 'RuboCop::Airbnb::Plugin'

  spec.add_dependency('lint_roller', '~> 1.1')
  spec.add_dependency('rubocop', '~> 1.72')
  spec.add_dependency('rubocop-capybara', '~> 2.22')
  spec.add_dependency('rubocop-factory_bot', '~> 2.27')
  spec.add_dependency('rubocop-performance', '~> 1.24')
  spec.add_dependency('rubocop-rails', '~> 2.30')
  spec.add_dependency('rubocop-rspec', '~> 3.5')
  spec.add_development_dependency('rspec', '~> 3.5')
end
