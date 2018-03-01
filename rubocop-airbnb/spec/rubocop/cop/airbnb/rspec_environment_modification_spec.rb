describe RuboCop::Cop::Airbnb::RspecEnvironmentModification do
  subject(:cop) { described_class.new }

  before(:each) do
    allow(cop).to receive(:is_spec_file?).and_return(true)
  end

  it 'does not allow assignment of Rails.env' do
    source = [
      'Rails.env = :production',
    ].join("\n")
    inspect_source(source)
    expect(cop.offenses.size).to eql(1)
  end

  it 'allows assignment of Rails.env when not in spec' do
    allow(cop).to receive(:is_spec_file?).and_return(false)
    source = [
      'Rails.env = :production',
    ].join("\n")
    inspect_source(source)
    expect(cop.offenses).to be_empty
  end

  it 'rejects allow style stubbing of Rails.env' do
    source = [
      'def some_method(a)',
      '  allow(Rails.env).to receive(:production?)',
      'end',
    ].join("\n")
    inspect_source(source)
    expect(cop.offenses.size).to eql(1)
  end

  it 'rejects expect style stubbing of Rails.env' do
    source = [
      'def some_method(a)',
      '  expect(Rails.env).to receive(:production?)',
      'end',
    ].join("\n")
    inspect_source(source)
    expect(cop.offenses.size).to eql(1)
  end

  it 'rejects .stub stubbing of Rails.env' do
    source = [
      'def some_method(a)',
      '  Rails.env.stub(:production)',
      'end',
    ].join("\n")
    inspect_source(source)
    expect(cop.offenses.size).to eql(1)
  end

  it 'allows stub_env' do
    source = [
      'def some_method(a)',
      '  stub_env(:production)',
      'end',
    ].join("\n")
    inspect_source(source)
    expect(cop.offenses).to be_empty
  end
end
