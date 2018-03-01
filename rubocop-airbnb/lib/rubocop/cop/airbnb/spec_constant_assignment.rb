require 'rubocop-rspec'

module RuboCop
  module Cop
    module Airbnb
      # This cop checks for constant assignment inside of specs
      #
      # @example
      #   # bad
      #   describe Something do
      #     PAYLOAD = [1, 2, 3]
      #   end
      #
      #   # good
      #   describe Something do
      #     let(:payload)  { [1, 2, 3] }
      #   end
      #
      #   # bad
      #   describe Something do
      #     MyClass::PAYLOAD = [1, 2, 3]
      #   end
      #
      #   # good
      #   describe Something do
      #     before { stub_const('MyClass::PAYLOAD', [1, 2, 3])
      #   end
      class SpecConstantAssignment < Cop
        include RuboCop::RSpec::TopLevelDescribe
        MESSAGE = "Defining constants inside of specs can cause spurious behavior. " \
                  "It is almost always preferable to use `let` statements, "\
                  "anonymous class/module definitions, or stub_const".freeze

        def on_casgn(node)
          return unless in_spec_file?(node)
          parent_module_name = node.parent_module_name
          if node.parent_module_name && parent_module_name != 'Object'
            return
          end
          add_offense(node, message: MESSAGE)
        end

        private

        def in_spec_file?(node)
          filename = node.location.expression.source_buffer.name

          # For tests, the input is a string
          return true if filename == "(string)"
          filename.include?("/spec/")
        end
      end
    end
  end
end
