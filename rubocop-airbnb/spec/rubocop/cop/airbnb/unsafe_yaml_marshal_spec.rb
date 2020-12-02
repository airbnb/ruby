describe RuboCop::Cop::Airbnb::UnsafeYamlMarshal, :config do
  context 'send' do
    it 'rejects YAML.load' do
      expect_offense(<<~RUBY)
        def some_method(a)
          YAML.load(a)
          ^^^^^^^^^^^^ Using `YAML.load` on untrusted input [...]
        end
      RUBY
    end

    it 'rejects Psych.load' do
      expect_offense(<<~RUBY)
        def some_method(a)
          Psych.load(a)
          ^^^^^^^^^^^^^ Using `Psych.load` on untrusted input [...]
        end
      RUBY
    end

    it 'accepts YAML.safe_load' do
      expect_no_offenses(<<~RUBY)
        def some_method(a)
          YAML.safe_load(a)
        end
      RUBY
    end

    it 'rejects on Marshal.load' do
      expect_offense(<<~RUBY)
        def some_method(a)
          Marshal.load(a)
          ^^^^^^^^^^^^^^^ Using `Marshal.load` on untrusted input can lead to remote code execution. [...]
        end
      RUBY
    end
  end
end
