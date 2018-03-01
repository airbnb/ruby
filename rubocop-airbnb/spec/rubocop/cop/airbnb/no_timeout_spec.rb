describe RuboCop::Cop::Airbnb::NoTimeout do
  subject(:cop) { described_class.new }

  context 'send' do
    it 'rejects Timeout.timeout' do
      source = [
        'def some_method(a)',
        '  Timeout.timeout(5) do',
        '    some_other_method(a)',
        '  end',
        'end',
      ].join("\n")
      inspect_source(source)
      expect(cop.offenses.size).to eql(1)
      expect(cop.offenses.first.message).to start_with('Do not use Timeout.timeout')
    end

    it 'accepts foo.timeout' do
      source = [
        'def some_method(a)',
        '  foo.timeout do',
        '    some_other_method(a)',
        '  end',
        'end',
      ].join("\n")
      inspect_source(source)
      expect(cop.offenses).to be_empty
    end
  end
end
