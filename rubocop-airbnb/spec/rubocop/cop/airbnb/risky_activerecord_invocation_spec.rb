describe RuboCop::Cop::Airbnb::RiskyActiverecordInvocation, :config do
  it "allows where statement that's a hash" do
    expect_no_offenses(<<~RUBY)
      Users.where({:name => "Bob"})
    RUBY
  end

  it "allows where statement that's a flat string" do
    expect_no_offenses('Users.where("age = 24")')
  end

  it "allows a multiline where statement" do
    expect_no_offenses("Users.where(\"age = 24 OR \" \\\n\"age = 25\")")
  end

  it "allows interpolation in subsequent arguments to where" do
    expect_no_offenses('Users.where("name like ?", "%#{name}%")')
  end

  it "disallows interpolation in where statements" do
    expect_offense(<<~RUBY)
      Users.where("name = \#{username}")
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Passing a string computed by interpolation or addition to an ActiveRecord method is likely to lead to SQL injection. [...]
    RUBY
  end

  it "disallows addition in where statements" do
    expect_offense(<<~RUBY)
      Users.where("name = " + username)
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Passing a string computed by interpolation or addition to an ActiveRecord method is likely to lead to SQL injection. [...]
    RUBY
  end

  it "disallows interpolation in order statements" do
    expect_offense(<<~RUBY)
      Users.where("age = 24").order("name \#{sortorder}")
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Passing a string computed by interpolation or addition to an ActiveRecord method is likely to lead to SQL injection. [...]
    RUBY
  end
end
