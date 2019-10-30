module RuboCop
  module Cop
    module Airbnb
      class ContinuationSlash < Cop
        MSG = 'Slash continuation should be reserved for closed string continuation. ' \
              'Many times it is used to get around other existing rules.'.freeze

        def enforce_violation(node)
          return if node.source.match(/["']\s*\\\n/)
          return unless node.source.match(/\\\n/)
          add_offense(node, message: message)
        end

        alias on_send enforce_violation
        alias on_if enforce_violation

        assignments = if Gem.loaded_specs['rubocop'].version < Gem::Version.new('0.59.0')
          RuboCop::Util::ASGN_NODES
        else
          RuboCop::AST::Node::ASSIGNMENTS
        end

         assignments.each do |type|
          define_method("on_#{type}") do |node|
            enforce_violation(node)
          end
        end
      end
    end
  end
end
