module RuboCop
  module Cop
    module Airbnb
      # Cop to help prevent the scorge of Default Scopes from ActiveRecord.
      # Once in place they are almost impossible to remove.
      class DefaultScope < Cop
        MSG = 'Avoid `default_scope`.  Default scopes make it difficult to '\
              'refactor data access patterns since the scope becomes part '\
              'of every query unless explicitly excluded, even when it is '\
              'unnecessary or incidental to the desired logic.'.freeze

        def on_send(node)
          return unless node.command?(:default_scope)

          add_offense(node)
        end
      end
    end
  end
end
