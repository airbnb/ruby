module RuboCop
  module Cop
    module Airbnb
      # Prefer matching Phrase Bundle and t call keys inside of
      # PhraseBundleClasses.
      #
      # @example
      #   # bad
      #   def phrases
      #     {
      #       "shortened_key" => t(
      #         "my_real_translation_key",
      #         default: 'Does not matter',
      #       ),
      #     }
      #   end
      #
      #   # good
      #   def phrases
      #     {
      #       "my_real_translation_key" => t(
      #         "my_real_translation_key",
      #         default: 'Does not matter',
      #       ),
      #     }
      #   end
      class PhraseBundleKeys < Cop
        MESSAGE =
          'Phrase bundle keys should match their translation keys.'.freeze

        def on_send(node)
          parent = node.parent
          if t_call?(node) && in_phrase_bundle_class?(node) && parent.pair_type?
            hash_key = parent.children[0]
            unless hash_key.children[0] == node.children[2].children[0]
              add_offense(hash_key, message: MESSAGE)
            end
          end
        end

        private

        def in_phrase_bundle_class?(node)
          if node.class_type? && !const_phrase_bundle_children(node).empty?
            true
          elsif node.parent
            in_phrase_bundle_class?(node.parent)
          else
            false
          end
        end

        def const_phrase_bundle_children(node)
          node.children.select do |e|
            e.is_a?(Parser::AST::Node) &&
              e.const_type? &&
              e.children[1] == :PhraseBundle
          end
        end

        def t_call?(node)
          node.children[1] == :t
        end
      end
    end
  end
end
