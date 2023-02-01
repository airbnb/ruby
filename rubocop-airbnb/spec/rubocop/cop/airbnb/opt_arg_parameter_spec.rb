describe RuboCop::Cop::Airbnb::OptArgParameters, :config do
  it 'allows method with no parameters' do
    expect_no_offenses(<<~RUBY)
      def my_method
      end
    RUBY
  end

  it 'allows method with one parameter' do
    expect_no_offenses(<<~RUBY)
      def my_method(params)
      end
    RUBY
  end

  it 'allows method with one parameter with a default hash value' do
    expect_no_offenses(<<~RUBY)
      def my_method(params = {})
      end
    RUBY
  end

  it 'allows method named default parameters' do
    expect_no_offenses(<<~RUBY)
      def my_method(a, b, c: 5, d: 6)
      end
    RUBY
  end

  it 'allows method with multiple parameter with a default hash value' do
    expect_no_offenses(<<~RUBY)
      def my_method(a, b, c, params = {})
      end
    RUBY
  end

  it 'allows method with default parameter before block parameter' do
    expect_no_offenses(<<~RUBY)
      def my_method(a, b, c, params = {}, &block)
      end
    RUBY
  end

  it 'rejects method with a default parameter other than the last non-block parameter' do
    expect_offense(<<~RUBY)
      def my_method(a, b = nil, c, &block)
                       ^^^^^^^ Do not use default positional arguments. [...]
      end
    RUBY
  end

  it 'rejects method with a default parameter other than the last parameter' do
    expect_offense(<<~RUBY)
      def my_method(a, b = 5, c = nil, params = {})
                       ^^^^^ Do not use default positional arguments. [...]
                              ^^^^^^^ Do not use default positional arguments. [...]
      end
    RUBY
  end

  it 'rejects method where last parameter has a default value of nil' do
    expect_offense(<<~RUBY)
      def my_method(a, b, c, params = nil)
                             ^^^^^^^^^^^^ Do not use default positional arguments. [...]
      end
    RUBY
  end

  it 'rejects method where last parameter has a default value of a constant' do
    expect_offense(<<~RUBY)
      def my_method(a, b, c, params = Constants::A_CONSTANT)
                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not use default positional arguments. [...]
      end
    RUBY
  end
end
