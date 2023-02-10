describe RuboCop::Cop::Airbnb::ContinuationSlash, :config do
  it 'rejects continuations used to continue a method call with trailing dot' do
    expect_offense(<<~RUBY)
      User. \\
      ^^^^^^^ Slash continuation should be reserved [...]
        first_name
    RUBY
  end

  context 'on assignment' do
    it 'rejects on constant assignment' do
      expect_offense(<<~RUBY)
        CONSTANT = "I am a string that \\
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Slash continuation should be reserved [...]
          spans multiple lines"
      RUBY
    end

    it 'rejects on local variable assignment' do
      expect_offense(<<~RUBY)
        variable = "I am a string that \\
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Slash continuation should be reserved [...]
          spans multiple lines"
      RUBY
    end

    it 'rejects on @var assignment' do
      expect_offense(<<~RUBY)
        class SomeClass
          @class_var = "I am a string that \\
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Slash continuation should be reserved [...]
            spans multiple lines"
        end
      RUBY
    end

    it 'rejects on @@var assignment' do
      expect_offense(<<~RUBY)
        class SomeClass
          @@class_var = "I am a string that \\
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Slash continuation should be reserved [...]
            spans multiple lines"
        end
      RUBY
    end
  end

  context 'in conditional continuation' do
    it 'rejects if with continuation \\ before operator' do
      expect_offense(<<~RUBY)
        if true \\
        ^^^^^^^^^ Slash continuation should be reserved [...]
           && false
          return false
        end
      RUBY
    end

    it 'rejects unless with continuation \\' do
      expect_offense(<<~RUBY)
        unless true \\
        ^^^^^^^^^^^^^ Slash continuation should be reserved [...]
           && false
          return false
        end
      RUBY
    end

    it 'rejects if with continuation \\ after operator' do
      expect_offense(<<~RUBY)
        if true || \\
        ^^^^^^^^^^^^ Slash continuation should be reserved [...]
           false
          return false
        end
      RUBY
    end
  end

  context 'open string continuation' do
    it 'rejects contination with space before \\' do
      expect_offense(<<~RUBY)
        I18n.t("I am a string that \\
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Slash continuation should be reserved [...]
          spans multiple lines")
      RUBY
    end

    it 'rejects contination with no space before \\' do
      expect_offense(<<~RUBY)
        I18n.t(\'I am a string that \\
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Slash continuation should be reserved [...]
          spans multiple lines\')
      RUBY
    end
  end

  context 'closed string continuation' do
    it 'allows double quote string with no space before \\' do
      expect_no_offenses(<<~RUBY)
        I18n.t("I am a string that "\\
          "spans multiple lines")
      RUBY
    end

    it 'allows double quote string with space before \\' do
      expect_no_offenses(<<~RUBY)
        I18n.t("I am a string that " \\
          "spans multiple lines")
      RUBY
    end

    it 'allows single quote string with no space before \\' do
      expect_no_offenses(<<~RUBY)
        I18n.t(\'I am a string that \'\\
          \'spans multiple lines\')
      RUBY
    end

    it 'allows single quote string with space before \\' do
      expect_no_offenses(<<~RUBY)
        I18n.t(\'I am a string that \' \\
          \'spans multiple lines\')
      RUBY
    end
  end
end
