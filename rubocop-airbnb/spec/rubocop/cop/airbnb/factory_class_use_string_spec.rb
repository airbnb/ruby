describe RuboCop::Cop::Airbnb::FactoryClassUseString, :config do
  it 'rejects with :class => Model' do
    expect_offense(<<~RUBY)
      factory :help_answer, :class => Help::Answer do
                            ^^^^^^^^^^^^^^^^^^^^^^ Instead of :class => MyClass, use :class => "MyClass". [...]
        text { Faker::Company.name }
      end
    RUBY
  end

  it 'passes with :class => "Model"' do
    expect_no_offenses(<<~RUBY)
      factory :help_answer, :class => "Help::Answer" do
        text { Faker::Company.name }
      end
    RUBY
  end
end
