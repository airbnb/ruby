module RuboCop
  module Cop
    module Airbnb
      class NoTimeout < Cop
        MSG =
          'Do not use Timeout.timeout. In combination with Rails autoloading, ' \
          'timeout can cause Segmentation Faults in version of Ruby we use. ' \
          'It can also cause logic errors since it can raise in ' \
          'any callee scope. Use client library timeouts and monitoring to ' \
          'ensure proper timing behavior for web requests.'.freeze

        def on_send(node)
          return unless node.source.start_with?('Timeout.timeout')
          add_offense(node, message: MSG)
        end
      end
    end
  end
end
