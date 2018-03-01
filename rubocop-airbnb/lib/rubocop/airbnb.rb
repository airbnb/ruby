require 'pathname'
require 'psych'

Dir.glob(File.expand_path('cop/**/*.rb', File.dirname(__FILE__))).map(&method(:require))

module RuboCop
  # RuboCop Airbnb project namespace
  module Airbnb
    PROJECT_ROOT =
      Pathname.new(__FILE__).parent.parent.parent.expand_path.freeze
    CONFIG_DEFAULT = PROJECT_ROOT.join('config', 'default.yml').freeze
    CONFIG = Psych.safe_load(CONFIG_DEFAULT.read).freeze

    private_constant(*constants(false))
  end
end
