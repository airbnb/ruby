module RuboCop
  module Cop
    module Airbnb
      # This cop checks for Rspec describe or context method calls under a namespace.
      # It can potentially cause autoloading to occur in a different order than it
      # would have in development or production. This could cause flaky tests.
      #
      # @example
      #   # bad
      #
      #   # spec/foo/bar_spec.rb
      #   module Foo
      #     describe Bar do
      #     end
      #   end
      #
      #   # good
      #
      #   # spec/foo/bar_spec.rb do
      #
      #   describe Foo::Bar
      #   end
      class RspecDescribeOrContextUnderNamespace < Cop
        DESCRIBE_OR_CONTEXT_UNDER_NAMESPACE_MSG =
          'Declaring a `module` in a spec can break autoloading because subsequent references ' \
          'to it will not cause it to be loaded from the app. This could cause flaky tests.'.freeze

        FIX_DESCRIBE_OR_CONTEXT_HELP_MSG =
          'Change `%{describe} %{klass} do` to `%{describe} %{module_name}::%{klass} do`.'.freeze

        FIX_CODE_HELP_MSG =
          'Remove `module %{module_name}` and fix `%{module_name}::CONST` and ' \
          '`%{module_name}.method` calls accordingly.'.freeze

        def_node_matcher :describe_or_context?,
                         '(send {(const nil? :RSpec) nil?} {:describe :context} ...)'.freeze

        def on_module(node)
          path = node.source_range.source_buffer.name
          return unless is_spec_file?(path)

          matched_node = search_children_for_describe_or_context(node.children)
          return unless matched_node

          method_name = matched_node.method_name
          module_name = get_module_name(node)
          message = [DESCRIBE_OR_CONTEXT_UNDER_NAMESPACE_MSG]

          described_class = get_described_class(matched_node)
          method_parent = get_method_parent(matched_node)
          parent_dot_method = method_parent ? "#{method_parent}.#{method_name}" : method_name
          if described_class
            message << FIX_DESCRIBE_OR_CONTEXT_HELP_MSG % {
              describe: parent_dot_method,
              klass: described_class,
              module_name: module_name,
            }
          end

          message << FIX_CODE_HELP_MSG % { module_name: module_name }
          add_offense(node, message: message.join(' '))
        end

        def search_children_for_describe_or_context(nodes)
          blocks = []
          # match nodes for send describe or context
          nodes.detect do |node|
            next unless node

            if is_block?(node)
              blocks << node
              next
            end
            return node if describe_or_context?(node)
          end

          # Process child nodes of block
          blocks.each do |node|
            matched_node = search_children_for_describe_or_context(node.children)
            return matched_node if matched_node
          end

          nil
        end

        def is_spec_file?(path)
          path.end_with?('_spec.rb')
        end

        def get_module_name(node)
          const_node = node.children[0]
          return unless const_node
          const_node.const_name
        end

        def get_described_class(node)
          const_node = node.children[2]
          return unless const_node
          const_node.const_name
        end

        def get_method_parent(node)
          const_node = node.children[0]
          return unless const_node
          const_node.const_name
        end

        def is_block?(node)
          node && [:block, :begin].include?(node.type)
        end
      end
    end
  end
end
