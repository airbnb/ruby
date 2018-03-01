module RuboCop
  module Cop
    module Airbnb
      # Cop to enforce "attr { CONST }" instead of "attr CONST" in factories,
      # because the latter forces autoload, which slows down spec startup time and
      # Zeus reload time after touching a model.
      class FactoryAttrReferencesClass < Cop
        MSG = "Instead of attr_name MyClass::MY_CONST, use attr_name { MyClass::MY_CONST }. " \
          "This enables faster spec startup time and Zeus reload time.".freeze

        def_node_search :factory_attributes, <<-PATTERN
          (block (send nil {:factory :trait} ...) _ { (begin $...) $(send ...) } )
        PATTERN

        # Look for "attr CONST" expressions in factories or traits. In RuboCop, this is
        # a `send` node, sending the attr method.
        def on_send(node)
          return unless in_factory_file?(node)
          return unless in_factory_or_trait?(node)

          add_const_offenses(node)
        end

        private

        def in_factory_file?(node)
          filename = node.location.expression.source_buffer.name

          # For tests, the input is a string
          filename.include?("spec/factories/") || filename == "(string)"
        end

        # Is this node in a factory or trait, but not inside a nested block in a factory or trait?
        def in_factory_or_trait?(node)
          return false unless node

          # Bail out if this IS the factory or trait node.
          return false unless factory_attributes(node)
          return false unless node.parent

          # Is this node in a block that was passed to the factory or trait method?
          if node.parent.is_a?(RuboCop::AST::Node) && node.parent.block_type?
            send_node = node.parent.children.first
            return false unless send_node
            return false unless send_node.send_type?

            # Const is referenced in the block passed to a factory or trait.
            return true if send_node.command?(:factory)
            return true if send_node.command?(:trait)

            # Const is a block that's nested deeper inside a factory or trait. This is what we want
            # developers to do.
            return false
          end

          in_factory_or_trait?(node.parent)
        end

        def add_const_offenses(node)
          # Add an offense for any const reference
          node.each_child_node(:const) do |const_node|
            add_offense(const_node)
          end

          # Recurse into arrays, hashes, and method calls such as ConstName[:symbol],
          # adding offenses for any const reference inside them.
          node.each_child_node(:array, :hash, :pair, :send) do |array_node|
            add_const_offenses(array_node)
          end
        end
      end
    end
  end
end
