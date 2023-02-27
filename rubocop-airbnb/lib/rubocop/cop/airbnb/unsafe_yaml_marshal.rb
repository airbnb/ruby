module RuboCop
  module Cop
    module Airbnb
      # Disallow use of YAML/Marshal methods that can trigger RCE on untrusted input
      class UnsafeYamlMarshal < Base
        MSG = 'Using unsafe YAML parsing methods on untrusted input can lead ' \
              'to remote code execution. Use `safe_load`, `parse`, `parse_file`, or ' \
              '`parse_stream` instead'.freeze
        RESTRICT_ON_SEND = %i(load load_documents load_file load_stream).freeze

        def on_send(node)
          return if node.receiver.nil?
          return unless node.receiver.const_type?

          check_yaml(node)
          check_marshal(node)
        rescue => e
          puts e
          puts e.backtrace
          raise
        end

        def check_yaml(node)
          const_name = node.receiver.const_name
          return unless ['YAML', 'Psych'].include?(const_name)

          message = "Using `#{const_name}.#{node.method_name}` on untrusted input can lead " \
            "to remote code execution. Use `safe_load`, `parse`, `parse_file`, or " \
            "`parse_stream` instead"

          add_offense(node, message: message)
        end

        def check_marshal(node)
          return unless node.receiver.const_name == 'Marshal'
          return unless node.method?(:load)

          message = 'Using `Marshal.load` on untrusted input can lead to remote code execution. ' \
            'Restructure your code to not use Marshal'

          add_offense(node, message: message)
        end
      end
    end
  end
end
