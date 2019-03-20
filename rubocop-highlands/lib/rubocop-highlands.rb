require 'pathname'
require 'yaml'

# Load original rubocop gem
require 'rubocop'

require 'rubocop/highlands'
require 'rubocop/highlands/inject'
require 'rubocop/highlands/version'

RuboCop::Highlands::Inject.defaults!
