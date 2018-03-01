require_relative '../../airbnb/inflections'
require_relative '../../airbnb/rails_autoloading'

module RuboCop
  module Cop
    module Airbnb
      # This cop checks for a constant assigned in a file that does not match its owning scope.
      # The Rails autoloader can't find such a constant, but sometimes
      # people "get lucky" if the file happened to be loaded before the method was defined.
      #
      # @example
      #   # bad
      #
      #   # foo/bar.rb
      #   module Foo
      #     BAZ = 42
      #   end
      #
      #   # good
      #
      #   # foo.rb
      #   module Foo
      #     BAZ = 42
      #   end
      class ConstAssignedInWrongFile < Cop
        include Inflections
        include RailsAutoloading

        # FOO = 42
        ASSIGNMENT_MSG =
          "In order for Rails autoloading to be able to find and load this file when " \
          "someone references this const, move the const assignment to a file that defines " \
          "the owning module. Const %s should be defined in %s.".freeze
        # FOO = 42 at global scope
        GLOBAL_ASSIGNMENT =
          "In order for Rails autoloading to be able to find and load this file when " \
          "someone references this const, move the const assignment to a file that defines " \
          "the owning module. Const %s should be moved into a namespace or defined in %s.".freeze

        # FOO = 42
        def on_casgn(node)
          path = node.source_range.source_buffer.name
          return unless run_rails_autoloading_cops?(path)
          return unless node.parent_module_name

          # Ignore assignments like Foo::Bar = 42
          return if node.children[0]

          const_name = node.children[1]
          parent_module_name = normalize_module_name(node.parent_module_name)
          fully_qualified_const_name = full_const_name(parent_module_name, const_name)
          expected_dir = underscore(fully_qualified_const_name)
          allowable_paths = allowable_paths_for(expected_dir)
          if allowable_paths.none? { |allowable_path| path =~ allowable_path }
            add_error(const_name, node)
          end
        end

        private

        def add_error(const_name, node)
          parent_module_names = split_modules(node.parent_module_name)
          expected_file = "#{parent_module_names.map { |name| underscore(name) }.join("/")}.rb"
          if expected_file == ".rb" # global namespace
            expected_file = "#{underscore(const_name)}.rb"
            add_offense(node, message: GLOBAL_ASSIGNMENT % [const_name, expected_file])
          else
            add_offense(node, message: ASSIGNMENT_MSG % [const_name, expected_file])
          end
        end
      end
    end
  end
end
