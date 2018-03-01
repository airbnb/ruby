module RuboCop
  module Cop
    module Airbnb
      # Cop to enforce use of options hash over default arguments
      # https://github.com/airbnb/ruby#no-default-args
      class OptArgParameters < Cop
        MSG =
          'Do not use default positional arguments. '\
          'Use keyword arguments or an options hash instead.'.freeze

        def on_args(node)
          *but_last, last_arg = *node

          if last_arg && last_arg.blockarg_type?
            last_arg = but_last.pop
          end

          but_last.each do |arg|
            next unless arg.optarg_type?
            add_offense(arg, message: MSG)
          end
          return if last_arg.nil?

          return unless last_arg.optarg_type?

          _arg_name, default_value = *last_arg
          if default_value.hash_type?
            # asserting default value is empty hash
            *key_value_pairs = *default_value
            return if key_value_pairs.empty?
          end

          add_offense(last_arg, message: MSG)
        end
      end
    end
  end
end
