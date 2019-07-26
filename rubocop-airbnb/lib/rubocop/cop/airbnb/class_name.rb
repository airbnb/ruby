module RuboCop
  module Cop
    module Airbnb
      # Cop to prevent cross-model references, which result in a cascade of autoloads. E.g.,
      # belongs_to :user, :class_name => User.name
      class ClassName < Cop
        MSG = 'Use "Model" instead of Model.name at class scope to avoid cross-model references. ' \
          'They cause a long cascade of autoloading, slowing down app startup and slowing down ' \
          'reloading of zeus after changing a model.'.freeze

        # Is this a has_many, has_one, or belongs_to with a :class_name arg? Make sure the
        # class name is a hardcoded string or symbol. If not, add an offense and return true.
        def on_send(node)
          association_statement =
            node.command?(:has_many) ||
            node.command?(:has_one) ||
            node.command?(:belongs_to)

          return unless association_statement

          class_pair = class_name_node(node)

          if class_pair && !valid_class_name?(class_pair)
            add_offense(class_pair)
          end
        end

        private

        # Return the descendant node that is a hash pair (:key => value) whose key
        # is :class_name.
        def class_name_node(node)
          node.descendants.detect do |e|
            e.is_a?(Parser::AST::Node) &&
              e.pair_type? &&
              e.children[0].children[0] == :class_name
          end
        end

        # Given a hash pair :class_name => value, is the value a hardcoded string or symbol?
        def valid_class_name?(class_pair)
          name = class_pair.children[1]
          name.str_type? || name.sym_type?
        end
      end
    end
  end
end
