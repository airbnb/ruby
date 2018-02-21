describe RuboCop::Cop::Airbnb::SpecConstantAssignment do
  subject(:cop) { described_class.new }

  it 'rejects constant definition inside of a describe block' do
    source = [
      'describe Someclass do',
      '  CONSTANT = 5',
      'end',
    ].join("\n")

    inspect_source(source)
    expect(cop.offenses.size).to eq(1)
  end

  it 'allows constant defined inside of a module' do
    source = [
      'module Someclass',
      '  CONSTANT = 5',
      'end',
    ].join("\n")

    inspect_source(source)
    expect(cop.offenses).to be_empty
  end

  it 'allows constant defined in global space' do
    source = [
      'CONSTANT = 5',
    ].join("\n")

    inspect_source(source)
    expect(cop.offenses.size).to eq(1)
  end

  it 'rejects constant assignment inside a before block' do
    source = [
      'describe Someclass do',
      '  before { CONSTANT = 5 }',
      'end',
    ].join("\n")

    inspect_source(source)
    expect(cop.offenses.size).to eq(1)
  end

  it 'rejects namespaced constant assignment inside a before block' do
    source = [
      'describe Someclass do',
      '  before { MyModule::CONSTANT = 5 }',
      'end',
    ].join("\n")

    inspect_source(source)
    expect(cop.offenses.size).to eq(1)
  end

  it 'rejects constant assignment inside it block' do
    source = [
      'describe Someclass do',
      '  it "tests stuff" do',
      '    CONSTANT = 5',
      '  end',
      'end',
    ].join("\n")

    inspect_source(source)
    expect(cop.offenses.size).to eq(1)
  end

  it 'allows let statements that do not assign constants' do
    source = [
      'describe Someclass do',
      '  let(:constant) { 5 }',
      'end',
    ].join("\n")

    inspect_source(source)
    expect(cop.offenses).to be_empty
  end
end
