require_relative '../../airbnb/inflections'
require_relative '../../airbnb/rails_autoloading'

module RuboCop
  module Cop
    module Airbnb
      # This cop checks for methods defined in a module declaration, in a file that doesn't
      # match the module name. The Rails autoloader can't find such a method, but sometimes
      # people "get lucky" if the file happened to be loaded before the method was defined.
      #
      # @example
      #   # bad
      #
      #   # foo/bar.rb
      #   module Foo
      #     class Bar
      #     end
      #
      #     def baz
      #       42
      #     end
      #   end
      #
      #   # good
      #
      #   # foo/bar.rb
      #   module Foo
      #     class Bar
      #     end
      #   end
      #
      #   # foo.rb
      #   module Foo
      #     def baz
      #       42
      #     end
      #   end
      #
      # Note that autoloading works fine if classes are defined in the file that defines
      # the module. This is common usage for things like error classes, so we'll allow it:
      #
      # @example
      #   # good
      #
      #   # foo.rb
      #   module Foo
      #     class Bar < StandardError
      #       def baz
      #       end
      #     end
      #   end
      #
      #   # good
      #
      #   # foo.rb
      #   class Foo
      #     class Bar # nested class
      #       def baz
      #       end
      #     end
      #   end
      class ModuleMethodInWrongFile < Cop
        include Inflections
        include RailsAutoloading

        MSG_TEMPLATE =
          "In order for Rails autoloading to be able to find and load this file when " \
          "someone calls this method, move the method definition to a file that defines " \
          "the module. This file just uses the module as a namespace for another class " \
          "or module. Method %s should be defined in %s.".freeze

        def on_def(node)
          method_name, args, body = *node
          on_method_def(node, method_name, args, body)
        end

        alias on_defs on_def

        private

        def on_method_def(node, method_name, args, body)
          path = node.source_range.source_buffer.name
          return unless run_rails_autoloading_cops?(path)
          return unless node.parent_module_name
          # "#<Class:>" is the parent module name of a method being defined in an if/unless.
          return if node.parent_module_name == "#<Class:>"

          expected_dir = underscore(normalize_module_name(node.parent_module_name))
          allowable_filenames = expected_dir.split("/").map { |file| "#{file}.rb" }
          basename = File.basename(path)
          if !allowable_filenames.include?(basename)
            parent_module_names = split_modules(node.parent_module_name)
            expected_parent_module_file =
              "#{parent_module_names.map { |name| underscore(name) }.join("/")}.rb"
            add_offense(
              node,
              message: MSG_TEMPLATE % [method_name, expected_parent_module_file]
            )
          end
        end
      end
    end
  end
end
