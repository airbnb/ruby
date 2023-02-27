module RuboCop
  module Cop
    module Airbnb
      # Cop to help prevent the scorge of Default Scopes from ActiveRecord.
      # Once in place they are almost impossible to remove.
      class DefaultScope < Base
        MSG = 'Avoid `default_scope`.  Default scopes make it difficult to '\
              'refactor data access patterns since the scope becomes part '\
              'of every query unless explicitly excluded, even when it is '\
              'unnecessary or incidental to the desired logic.'.freeze
        RESTRICT_ON_SEND = %i(default_scope).freeze

        def on_send(node)
          return if node.receiver

          add_offense(node)
        end
      end
    end
  end
end
