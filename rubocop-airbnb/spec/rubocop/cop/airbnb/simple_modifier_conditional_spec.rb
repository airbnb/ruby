describe RuboCop::Cop::Airbnb::SimpleModifierConditional, :config do
  context 'multiple conditionals' do
    it 'rejects with modifier if with multiple conditionals' do
      expect_offense(<<~RUBY)
        return true if some_method == 0 || another_method
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Modifier if/unless usage is okay when [...]
      RUBY
    end

    it 'rejects with modifier unless with multiple conditionals' do
      expect_offense(<<~RUBY)
        return true unless true && false
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Modifier if/unless usage is okay when [...]
      RUBY
    end

    it 'allows with modifier if operator conditional' do
      expect_no_offenses(<<~RUBY)
        return true if some_method == 0
      RUBY
    end

    it 'allows with modifier if with single conditional' do
      expect_no_offenses(<<~RUBY)
        return true if some_method == 0
        return true if another_method
      RUBY
    end

    it 'allows with modifier if and unless with single conditional ' do
      expect_no_offenses(<<~RUBY)
        return true if some_method
        return true unless another_method > 5
      RUBY
    end

    it 'allows multiple conditionals in block form' do
      expect_no_offenses(<<~RUBY)
        if some_method == 0 && another_method > 5 || true || false
         return true
        end
      RUBY
    end
  end

  context 'multiple lines' do
    it 'rejects modifier conditionals that span multiple lines' do
      expect_offense(<<~RUBY)
        return true if true ||
        ^^^^^^^^^^^^^^^^^^^^^^ Modifier if/unless usage is okay when [...]
                       false
        return true unless true ||
        ^^^^^^^^^^^^^^^^^^^^^^^^^^ Modifier if/unless usage is okay when [...]
                           false
      RUBY
    end

    it 'rejects with modifier if with method that spans multiple lines' do
      expect_offense(<<~RUBY)
        return true if some_method(param1,
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Modifier if/unless usage is okay when [...]
                                   param2,
                                   param3)
        return true unless some_method(param1,
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Modifier if/unless usage is okay when [...]
                                       param2,
                                       param3)
      RUBY
    end

    it 'rejects inline if/unless after a multiline statement' do
      expect_offense(<<~RUBY)
        return some_method(
        ^^^^^^^^^^^^^^^^^^^ Modifier if/unless usage is okay when [...]
          param1,
          param2,
          param3
        ) if another_method == 0
        return some_method(
        ^^^^^^^^^^^^^^^^^^^ Modifier if/unless usage is okay when [...]
          param1,
          param2,
          param3
        ) unless another_method == 0
      RUBY
    end

    it 'allows multline conditionals in block form' do
      expect_no_offenses(<<~RUBY)
        if some_method(param1,
                       param2,
                       parma3)
         return true
        end
      RUBY
    end
  end
end
