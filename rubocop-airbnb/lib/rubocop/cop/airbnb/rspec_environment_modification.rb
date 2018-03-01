module RuboCop
  module Cop
    module Airbnb
      # This cop checks how the Rails environment is modified in specs. If an individual method on
      # Rails.env is modified multiple environment related branchs could be run down. Rather than
      # modifying a single path or setting Rails.env in a way that could bleed into other specs,
      # use `stub_env`
      #
      # @example
      #   # bad
      #
      #   # spec/foo/bar_spec.rb
      #   before(:each) do
      #     allow(Rails.env).to receive(:production).and_return(true)
      #   end
      #
      #   before(:each) do
      #     expect(Rails.env).to receive(:production).and_return(true)
      #   end
      #
      #   before(:each) do
      #     Rails.env = :production
      #   end
      #
      #   # good
      #
      #   # spec/foo/bar_spec.rb do
      #   before(:each) do
      #     stub_env(:production)
      #   end
      class RspecEnvironmentModification < Cop
        def_node_matcher :allow_or_expect_rails_env, <<-PATTERN
          (send (send nil? {:expect :allow} (send (const nil? :Rails) :env)) :to ...)
        PATTERN

        def_node_matcher :stub_rails_env, <<-PATTERN
          (send (send (const nil? :Rails) :env) :stub _)
        PATTERN

        def_node_matcher :rails_env_assignment, '(send (const nil? :Rails) :env= ...)'

        MESSAGE = "Do not stub or set Rails.env in specs. Use the `stub_env` method instead".freeze

        def on_send(node)
          path = node.source_range.source_buffer.name
          return unless is_spec_file?(path)
          if rails_env_assignment(node) || allow_or_expect_rails_env(node) || stub_rails_env(node)
            add_offense(node, message: MESSAGE)
          end
        end

        def is_spec_file?(path)
          path.end_with?('_spec.rb')
        end
      end
    end
  end
end
