module RuboCop
  module Cop
    module Airbnb
      # Cop to tell developers to use :class => "MyClass" instead of :class => MyClass,
      # because the latter slows down reloading zeus.
      class FactoryClassUseString < Cop
        MSG = 'Instead of :class => MyClass, use :class => "MyClass". ' \
          "This enables faster spec startup time and faster Zeus reload time.".freeze

        def on_send(node)
          return unless node.command?(:factory)

          class_pair = class_node(node)

          if class_pair && !string_class_name?(class_pair)
            add_offense(class_pair)
          end
        end

        private

        # Return the descendant node that is a hash pair (:key => value) whose key
        # is :class.
        def class_node(node)
          node.descendants.detect do |e|
            e.is_a?(Parser::AST::Node) &&
              e.pair_type? &&
              e.children[0].children[0] == :class
          end
        end

        # Given a hash pair :class_name => value, is the value a hardcoded string?
        def string_class_name?(class_pair)
          class_pair.children[1].str_type?
        end
      end
    end
  end
end
