describe RuboCop::Cop::Airbnb::RspecEnvironmentModification, :config do
  before(:each) do
    allow(cop).to receive(:is_spec_file?).and_return(true)
  end

  it 'does not allow assignment of Rails.env' do
    expect_offense(<<~RUBY)
      Rails.env = :production
      ^^^^^^^^^^^^^^^^^^^^^^^ Do not stub or set Rails.env in specs. [...]
    RUBY
  end

  it 'allows assignment of Rails.env when not in spec' do
    allow(cop).to receive(:is_spec_file?).and_return(false)
    expect_no_offenses(<<~RUBY)
      Rails.env = :production
    RUBY
  end

  it 'rejects allow style stubbing of Rails.env' do
    expect_offense(<<~RUBY)
      def some_method(a)
        allow(Rails.env).to receive(:production?)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not stub or set Rails.env in specs. [...]
      end
    RUBY
  end

  it 'rejects expect style stubbing of Rails.env' do
    expect_offense(<<~RUBY)
      def some_method(a)
        expect(Rails.env).to receive(:production?)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not stub or set Rails.env in specs. [...]
      end
    RUBY
  end

  it 'rejects .stub stubbing of Rails.env' do
    expect_offense(<<~RUBY)
      def some_method(a)
        Rails.env.stub(:production)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not stub or set Rails.env in specs. [...]
      end
    RUBY
  end

  it 'allows stub_env' do
    expect_no_offenses(<<~RUBY)
      def some_method(a)
        stub_env(:production)
      end
    RUBY
  end
end
