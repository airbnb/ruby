require 'pathname'
require 'yaml'

# Load original rubocop gem
require 'rubocop'

require 'rubocop/airbnb'
require 'rubocop/airbnb/inject'
require 'rubocop/airbnb/version'
require 'rubocop/airbnb/version'
require 'rubocop-performance'
require 'rubocop-rails'

RuboCop::Airbnb::Inject.defaults!
