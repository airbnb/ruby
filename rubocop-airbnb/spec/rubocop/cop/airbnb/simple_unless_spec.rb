describe RuboCop::Cop::Airbnb::SimpleUnless, :config do
  it 'rejects unless with multiple conditionals' do
    expect_offense(<<~RUBY)
      unless boolean_condition || another_method
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Unless usage is okay when there is only one conditional
        return true
      end
    RUBY
  end

  it 'allows if with multiple conditionals' do
    expect_no_offenses(<<~RUBY)
      if boolean_condition || another_method
        return true
      end
    RUBY
  end

  it 'allows with modifier if operator conditional' do
    expect_no_offenses(<<~RUBY)
      unless boolean_condition
        return true
      end
    RUBY
  end
end
