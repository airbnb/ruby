module RuboCop
  module Cop
    module Airbnb
      # Disallow use of YAML/Marshal methods that can trigger RCE on untrusted input
      class UnsafeYamlMarshal < Cop
        MSG = 'Using unsafe YAML parsing methods on untrusted input can lead ' \
              'to remote code execution. Use `safe_load`, `parse`, `parse_file`, or ' \
              '`parse_stream` instead'.freeze

        def on_send(node)
          receiver, method_name, *_args = *node

          return if receiver.nil?
          return unless receiver.const_type?

          check_yaml(node, receiver, method_name, *_args)
          check_marshal(node, receiver, method_name, *_args)
        rescue => e
          puts e
          puts e.backtrace
          raise
        end

        def check_yaml(node, receiver, method_name, *_args)
          return unless ['YAML', 'Psych'].include?(receiver.const_name)
          return unless [:load, :load_documents, :load_file, :load_stream].include?(method_name)

          message = "Using `#{receiver.const_name}.#{method_name}` on untrusted input can lead " \
            "to remote code execution. Use `safe_load`, `parse`, `parse_file`, or " \
            "`parse_stream` instead"

          add_offense(node, message: message)
        end

        def check_marshal(node, receiver, method_name, *_args)
          return unless receiver.const_name == 'Marshal'
          return unless method_name == :load

          message = 'Using `Marshal.load` on untrusted input can lead to remote code execution. ' \
            'Restructure your code to not use Marshal'

          add_offense(node, message: message)
        end
      end
    end
  end
end
