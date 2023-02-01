describe RuboCop::Cop::Airbnb::MassAssignmentAccessibleModifier, :config do
  it 'rejects when accessible= is called' do
    expect_offense(<<~RUBY)
      def some_method
        user = User.new
        user.accessible = [:first_name, :last_name]
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do no override and objects mass assignment restrictions.
        user.update_attributes(:first_name => "Walter", :last_name => "Udoing")
      end
    RUBY
  end

  it 'accepts when accessible= is not called' do
    expect_no_offenses(<<~RUBY)
      def some_method
        user = User.new
        user.first_name = "Walter"
        user.last_name = "Udoing"
        user.save!
      end
    RUBY
  end
end
