module RuboCop
  module Cop
    module Airbnb
      # Modifying Mass assignment restrictions eliminates the entire point of disabling
      # mass assignment. It's a lazy, potentially dangerous approach that should be discouraged.
      class MassAssignmentAccessibleModifier < Base
        MSG = 'Do no override and objects mass assignment restrictions.'.freeze
        RESTRICT_ON_SEND = %i(accessible=).freeze

        def on_send(node)
          add_offense(node, message: MSG)
        end
      end
    end
  end
end
