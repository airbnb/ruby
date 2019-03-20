module RuboCop
  module Cop
    module Highlands
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

        Util::ASGN_NODES.each do |type|
          define_method("on_#{type}") do |node|
            enforce_violation(node)
          end
        end
      end
    end
  end
end
