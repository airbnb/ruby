require 'pathname'
require 'yaml'

# Load original rubocop gem
require 'rubocop'

require 'rubocop-performance'
require 'rubocop-rails'

require_relative 'rubocop/airbnb'
require_relative 'rubocop/airbnb/plugin'
require_relative 'rubocop/airbnb/version'
