module RuboCop
  module Cop
    module Airbnb
      class NoTimeout < Base
        MSG =
          'Do not use Timeout.timeout. In combination with Rails autoloading, ' \
          'timeout can cause Segmentation Faults in version of Ruby we use. ' \
          'It can also cause logic errors since it can raise in ' \
          'any callee scope. Use client library timeouts and monitoring to ' \
          'ensure proper timing behavior for web requests.'.freeze
        RESTRICT_ON_SEND = %i(timeout).freeze

        def_node_matcher :timeout_const?, <<~PATTERN
          (const {cbase nil?} :Timeout)
        PATTERN

        def on_send(node)
          return unless timeout_const?(node.receiver)
          add_offense(node, message: MSG)
        end
      end
    end
  end
end
