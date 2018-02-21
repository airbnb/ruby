require_relative '../../airbnb/inflections'
require_relative '../../airbnb/rails_autoloading'

module RuboCop
  module Cop
    module Airbnb
      # This cop checks for a class or module declared in a file that does not match its name.
      # The Rails autoloader can't find such a constant, but sometimes
      # people "get lucky" if the file happened to be loaded before the method was defined.
      #
      # @example
      #   # bad
      #
      #   # foo/bar.rb
      #   module Foo
      #     class Goop
      #     end
      #
      #     module Moo
      #     end
      #   end
      #
      #   # good
      #
      #   # foo.rb
      #
      #   # foo/goop.rb
      #   module Foo
      #     class Goop
      #     end
      #   end
      #
      #   # foo/moo.rb
      #   module Foo
      #     module Moo
      #     end
      #   end
      #
      # Note that autoloading works fine if classes are defined in the file that defines
      # the module. This is common usage for things like error classes, so we'll allow it.
      # Nested classes are also allowed:
      #
      # @example
      #   # good
      #
      #   # foo.rb
      #   module Foo
      #     class Bar < StandardError
      #     end
      #   end
      #
      #   # good
      #
      #   # foo.rb
      #   class Foo
      #     class Bar # nested class
      #     end
      #   end
      class ClassOrModuleDeclaredInWrongFile < Cop
        include Inflections
        include RailsAutoloading

        # class Foo or module Foo in the wrong file
        CLASS_OR_MODULE_MSG =
          "In order for Rails autoloading to be able to find and load this file when " \
          "someone references this class/module, move its definition to a file that matches " \
          "its name. %s %s should be defined in %s.".freeze
        # class FooError < StandardError, in the wrong file
        ERROR_CLASS_MSG =
          "In order for Rails autoloading to be able to find and load this file when " \
          "someone references this class, move its definition to a file that defines " \
          "the owning module. Class %s should be defined in %s.".freeze

        # module M
        def on_module(node)
          on_class_or_module(node)
        end

        # class C
        def on_class(node)
          on_class_or_module(node)
        end

        private

        def on_class_or_module(node)
          path = node.source_range.source_buffer.name
          return unless run_rails_autoloading_cops?(path)

          const_name = node.loc.name.source
          parent_module_name = normalize_module_name(node.parent_module_name)
          fully_qualified_const_name = full_const_name(parent_module_name, const_name)
          expected_dir = underscore(fully_qualified_const_name)
          allowable_paths = allowable_paths_for(expected_dir, allow_dir: true)
          if allowable_paths.none? { |allowable_path| path =~ allowable_path }
            add_error(const_name, fully_qualified_const_name, node)
          end
        rescue => e
          puts e.backtrace
          raise
        end

        def add_error(const_name, fully_qualified_const_name, node)
          class_or_module = node.type.to_s.capitalize
          error_class = error_class?(node, class_or_module, const_name)
          if error_class
            parent_module_names = split_modules(node.parent_module_name)
          else
            parent_module_names = split_modules(fully_qualified_const_name)
          end
          expected_file = "#{parent_module_names.map { |name| underscore(name) }.join("/")}.rb"
          if error_class
            add_offense(node, message: ERROR_CLASS_MSG % [const_name, expected_file])
          else
            add_offense(
              node,
              message: CLASS_OR_MODULE_MSG % [class_or_module, const_name, expected_file]
            )
          end
        end

        # Does this node define an Error class? (Classname or base class includes the word
        # "Error" or "Exception".)
        def error_class?(node, class_or_module, const_name)
          return false unless class_or_module == "Class"
          _, base_class, *_ = *node
          return unless base_class
          base_class_name = base_class.children[1].to_s
          if const_name =~ /Error|Exception/ || base_class_name =~ /Error|Exception/
            return true
          end

          false
        end
      end
    end
  end
end
