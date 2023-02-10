describe RuboCop::Cop::Airbnb::FactoryAttrReferencesClass, :config do
  it 'rejects with `attr_name CONST_NAME` in a factory' do
    expect_offense(<<~RUBY)
      factory :reservation2 do
        status Reservation2::STATUS_NEW
               ^^^^^^^^^^^^^^^^^^^^^^^^ Instead of attr_name MyClass::MY_CONST, use attr_name { MyClass::MY_CONST }. [...]
      end
    RUBY
  end

  it 'passes with `attr_name { CONST_NAME }` in a factory' do
    expect_no_offenses(<<~RUBY)
      factory :reservation2 do
        status { Reservation2::STATUS_NEW }
      end
    RUBY
  end

  it 'rejects with `attr_name [CONST_NAME]`' do
    expect_offense(<<~RUBY)
      factory :reservation2 do
        statuses [Reservation2::STATUS_NEW]
                  ^^^^^^^^^^^^^^^^^^^^^^^^ Instead of attr_name MyClass::MY_CONST, use attr_name { MyClass::MY_CONST }. [...]
      end
    RUBY
  end

  it 'passes with `attr_name { [CONST_NAME] }`' do
    expect_no_offenses(<<~RUBY)
      factory :reservation2 do
        statuses { [Reservation2::STATUS_NEW] }
      end
    RUBY
  end

  it 'rejects with `attr_name [[CONST_NAME]]`' do
    expect_offense(<<~RUBY)
      factory :reservation2 do
        statuses [[Reservation2::STATUS_NEW]]
                   ^^^^^^^^^^^^^^^^^^^^^^^^ Instead of attr_name MyClass::MY_CONST, use attr_name { MyClass::MY_CONST }. [...]
      end
    RUBY
  end

  it 'passes with `attr_name { [[CONST_NAME]] }`' do
    expect_no_offenses(<<~RUBY)
      factory :reservation2 do
        statuses { [[Reservation2::STATUS_NEW]] }
      end
    RUBY
  end

  it 'rejects with `attr_name({ ConstName => something })' do
    expect_offense(<<~RUBY)
      factory :reservation2 do
        status_names({ Reservation2::STATUS_NEW => "new" })
                       ^^^^^^^^^^^^^^^^^^^^^^^^ Instead of attr_name MyClass::MY_CONST, use attr_name { MyClass::MY_CONST }. [...]
      end
    RUBY
  end

  it 'passes with `attr_name { { ConstName => something } }`' do
    expect_no_offenses(<<~RUBY)
      factory :reservation2 do
        status_names { { Reservation2::STATUS_NEW => "new" } }
      end
    RUBY
  end

  it 'rejects with `attr_name ConstName[:symbol]`' do
    expect_offense(<<~RUBY)
      factory :airlock_rule do
        stickiness Airlock::STICKINESS[:user]
                   ^^^^^^^^^^^^^^^^^^^ Instead of attr_name MyClass::MY_CONST, use attr_name { MyClass::MY_CONST }. [...]
      end
    RUBY
  end

  it 'passes with `attr_name { ConstName[:symbol] }`' do
    expect_no_offenses(<<~RUBY)
      factory :airlock_rule do
        stickiness { Airlock::STICKINESS[:user] }
      end
    RUBY
  end

  it 'rejects even if the const is not the first attr' do
    expect_offense(<<~RUBY)
      factory :reservation2 do
        trait :accepted do
          cancel_policy Hosting::CANCEL_FLEXIBLE
                        ^^^^^^^^^^^^^^^^^^^^^^^^ Instead of attr_name MyClass::MY_CONST, use attr_name { MyClass::MY_CONST }. [...]
          status Reservation2::STATUS_NEW
                 ^^^^^^^^^^^^^^^^^^^^^^^^ Instead of attr_name MyClass::MY_CONST, use attr_name { MyClass::MY_CONST }. [...]
        end
      end
    RUBY
  end

  it 'rejects with `attr_name CONST_NAME` in a trait' do
    expect_offense(<<~RUBY)
      factory :reservation2 do
        trait :accepted do
          status Reservation2::STATUS_NEW
                 ^^^^^^^^^^^^^^^^^^^^^^^^ Instead of attr_name MyClass::MY_CONST, use attr_name { MyClass::MY_CONST }. [...]
        end
      end
    RUBY
  end

  it 'passes with `attr_name { CONST_NAME }` in a trait' do
    expect_no_offenses(<<~RUBY)
      factory :reservation2 do
        trait :accepted do
          status { Reservation2::STATUS_NEW }
        end
      end
    RUBY
  end
end
