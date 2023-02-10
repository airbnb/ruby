describe RuboCop::Cop::Airbnb::SpecConstantAssignment, :config do
  it 'rejects constant definition inside of a describe block' do
    expect_offense(<<~RUBY)
      describe Someclass do
        CONSTANT = 5
        ^^^^^^^^^^^^ Defining constants inside of specs can cause spurious behavior. [...]
      end
    RUBY
  end

  it 'allows constant defined inside of a module' do
    expect_no_offenses(<<~RUBY)
      module Someclass
        CONSTANT = 5
      end
    RUBY
  end

  it 'rejects constant defined in global space' do
    expect_offense(<<~RUBY)
      CONSTANT = 5
      ^^^^^^^^^^^^ Defining constants inside of specs can cause spurious behavior. [...]
    RUBY
  end

  it 'rejects constant assignment inside a before block' do
    expect_offense(<<~RUBY)
      describe Someclass do
        before { CONSTANT = 5 }
                 ^^^^^^^^^^^^ Defining constants inside of specs can cause spurious behavior. [...]
      end
    RUBY
  end

  it 'rejects namespaced constant assignment inside a before block' do
    expect_offense(<<~RUBY)
      describe Someclass do
        before { MyModule::CONSTANT = 5 }
                 ^^^^^^^^^^^^^^^^^^^^^^ Defining constants inside of specs can cause spurious behavior. [...]
      end
    RUBY
  end

  it 'rejects constant assignment inside it block' do
    expect_offense(<<~RUBY)
      describe Someclass do
        it "tests stuff" do
          CONSTANT = 5
          ^^^^^^^^^^^^ Defining constants inside of specs can cause spurious behavior. [...]
        end
      end
    RUBY
  end

  it 'allows let statements that do not assign constants' do
    expect_no_offenses(<<~RUBY)
      describe Someclass do
        let(:constant) { 5 }
      end
    RUBY
  end
end
