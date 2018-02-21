describe RuboCop::Cop::Airbnb::MassAssignmentAccessibleModifier do
  subject(:cop) { described_class.new }

  it 'rejects when accessible= is called' do
    source = [
      'def some_method',
      '  user = User.new',
      '  user.accessible = [:first_name, :last_name]',
      '  user.update_attributes(:first_name => "Walter", :last_name => "Udoing")',
      'end',
    ].join("\n")
    inspect_source(source)
    expect(cop.offenses.size).to eq(1)
  end

  it 'accepts when accessible= is not called' do
    source = [
      'def some_method',
      '  user = User.new',
      '  user.first_name = "Walter"',
      '  user.last_name = "Udoing"',
      '  user.save!',
      'end',
    ].join("\n")
    inspect_source(source)
    expect(cop.offenses).to be_empty
  end
end
