module RuboCop
  module Cop
    module Highlands
      # Cop to tackle prevent unless statements with multiple conditions
      # https://github.com/highlands/ruby#unless-with-multiple-conditions
      class SimpleUnless < Cop
        MSG = 'Unless usage is okay when there is only one conditional'.freeze

        def_node_matcher :multiple_conditionals?, '(if ({and or :^} ...) ...)'

        def on_if(node)
          return unless node.unless?

          add_offense(node) if multiple_conditionals?(node)
        end
      end
    end
  end
end
