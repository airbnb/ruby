describe RuboCop::Cop::Airbnb::NoTimeout, :config do
  context 'send' do
    it 'rejects Timeout.timeout' do
      expect_offense(<<~RUBY)
        def some_method(a)
          Timeout.timeout(5) do
          ^^^^^^^^^^^^^^^^^^ Do not use Timeout.timeout. [...]
            some_other_method(a)
          end
        end
      RUBY
    end

    it 'accepts foo.timeout' do
      expect_no_offenses(<<~RUBY)
        def some_method(a)
          foo.timeout do
            some_other_method(a)
          end
        end
      RUBY
    end
  end
end
