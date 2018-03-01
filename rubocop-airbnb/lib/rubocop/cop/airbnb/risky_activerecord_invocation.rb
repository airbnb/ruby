module RuboCop
  module Cop
    module Airbnb
      # Disallow ActiveRecord calls that pass interpolated or added strings as an argument.
      class RiskyActiverecordInvocation < Cop
        VULNERABLE_AR_METHODS = [
          :delete_all,
          :destroy_all,
          :exists?,
          :execute,
          :find_by_sql,
          :group,
          :having,
          :insert,
          :order,
          :pluck,
          :reorder,
          :select,
          :select_rows,
          :select_values,
          :select_all,
          :update_all,
          :where,
        ].freeze
        MSG = 'Passing a string computed by interpolation or addition to an ActiveRecord ' \
              'method is likely to lead to SQL injection. Use hash or parameterized syntax. For ' \
              'more information, see ' \
              'http://guides.rubyonrails.org/security.html#sql-injection-countermeasures and ' \
              'https://rails-sqli.org/rails3. If you have confirmed with Security that this is a ' \
              'safe usage of this style, disable this alert with ' \
              '`# rubocop:disable Airbnb/RiskyActiverecordInvocation`.'.freeze
        def on_send(node)
          receiver, method_name, *_args = *node

          return if receiver.nil?
          return unless vulnerable_ar_method?(method_name)
          if !includes_interpolation?(_args) && !includes_sum?(_args)
            return
          end

          add_offense(node)
        end

        def vulnerable_ar_method?(method)
          VULNERABLE_AR_METHODS.include?(method)
        end

        # Return true if the first arg is a :dstr that has non-:str components
        def includes_interpolation?(args)
          !args.first.nil? &&
            args.first.type == :dstr &&
            args.first.each_child_node.any? { |child| child.type != :str }
        end

        def includes_sum?(args)
          !args.first.nil? &&
            args.first.type == :send &&
            args.first.method_name == :+
        end
      end
    end
  end
end
