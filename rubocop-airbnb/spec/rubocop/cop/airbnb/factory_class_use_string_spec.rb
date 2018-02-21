describe RuboCop::Cop::Airbnb::FactoryClassUseString do
  subject(:cop) { described_class.new }

  it 'rejects with :class => Model' do
    source = [
      'factory :help_answer, :class => Help::Answer do',
      '  text { Faker::Company.name }',
      'end',
    ].join("\n")
    inspect_source(source)

    expect(cop.offenses.size).to eq(1)
    expect(cop.offenses.map(&:line)).to eq([1])
  end

  it 'passes with :class => "Model"' do
    source = [
      'factory :help_answer, :class => "Help::Answer" do',
      '  text { Faker::Company.name }',
      'end',
    ].join("\n")
    inspect_source(source)

    expect(cop.offenses).to be_empty
  end
end
