# frozen_string_literal: true

require 'lint_roller'

module RuboCop
  module Airbnb
    # A plugin that integrates RuboCop Airbnb with RuboCop's plugin system.
    class Plugin < LintRoller::Plugin
      def about
        LintRoller::About.new(
          name: 'rubocop-airbnb',
          version: VERSION,
          homepage: 'https://github.com/airbnb/ruby',
          description: 'A plugin for RuboCop code style enforcing & linting tool.'
        )
      end

      def supported?(context)
        context.engine == :rubocop
      end

      def rules(_context)
        LintRoller::Rules.new(
          type: :path,
          config_format: :rubocop,
          value: Pathname.new(__dir__).join('../../../config/default.yml'),
        )
      end
    end
  end
end
