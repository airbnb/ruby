describe RuboCop::Cop::Airbnb::OptArgParameters do
  subject(:cop) { described_class.new }

  it 'allows method with no parameters' do
    source = [
      'def my_method',
      'end',
    ].join("\n")

    inspect_source(source)
    expect(cop.offenses).to be_empty
  end

  it 'allows method with one parameter' do
    source = [
      'def my_method(params)',
      'end',
    ].join("\n")

    inspect_source(source)
    expect(cop.offenses).to be_empty
  end

  it 'allows method with one parameter with a default hash value' do
    source = [
      'def my_method(params = {})',
      'end',
    ].join("\n")

    inspect_source(source)
    expect(cop.offenses).to be_empty
  end

  it 'allows method named default parameters' do
    source = [
      'def my_method(a, b, c: 5, d: 6)',
      'end',
    ].join("\n")

    inspect_source(source)
    expect(cop.offenses).to be_empty
  end

  it 'allows method with multiple parameter with a default hash value' do
    source = [
      'def my_method(a, b, c, params = {})',
      'end',
    ].join("\n")

    inspect_source(source)
    expect(cop.offenses).to be_empty
  end

  it 'allows method with default parameter before block parameter' do
    source = [
      'def my_method(a, b, c, params = {}, &block)',
      'end',
    ].join("\n")

    inspect_source(source)
    expect(cop.offenses).to be_empty
  end

  it 'rejects method with a default parameter other than the last non-block parameter' do
    source = [
      'def my_method(a, b = nil, c, &block)',
      'end',
    ].join("\n")

    inspect_source(source)
    expect(cop.offenses.size).to eq(1)
  end

  it 'rejects method with a default parameter other than the last parameter' do
    source = [
      'def my_method(a, b = 5, c = nil, params = {})',
      'end',
    ].join("\n")

    inspect_source(source)
    expect(cop.offenses.size).to eq(2)
  end

  it 'rejects method where last parameter has a default value of nil' do
    source = [
      'def my_method(a, b, c, params = nil)',
      'end',
    ].join("\n")

    inspect_source(source)
    expect(cop.offenses.size).to eq(1)
  end

  it 'rejects method where last parameter has a default value of a constant' do
    source = [
      'def my_method(a, b, c, params = Constants::A_CONSTANT)',
      'end',
    ].join("\n")

    inspect_source(source)
    expect(cop.offenses.size).to eq(1)
  end
end
