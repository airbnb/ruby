describe RuboCop::Cop::Airbnb::UnsafeYamlMarshal do
  subject(:cop) { described_class.new }

  context 'send' do
    it 'rejects YAML.load' do
      source = [
        'def some_method(a)',
        '  YAML.load(a)',
        'end',
      ].join("\n")
      inspect_source(source)
      expect(cop.offenses.size).to eql(1)
      expect(cop.offenses.first.message).to match(/`safe_load`, `parse`, `parse_file`/)
    end

    it 'rejects Psych.load' do
      source = [
        'def some_method(a)',
        '  Psych.load(a)',
        'end',
      ].join("\n")
      inspect_source(source)
      expect(cop.offenses.size).to eql(1)
      expect(cop.offenses.first.message).to match(/`safe_load`, `parse`, `parse_file`/)
    end

    it 'accepts YAML.safe_load' do
      source = [
        'def some_method(a)',
        '  YAML.safe_load(a)',
        'end',
      ].join("\n")
      inspect_source(source)
      expect(cop.offenses.size).to eql(0)
    end

    it 'rejects on Marshal.load' do
      source = [
        'def some_method(a)',
        '  Marshal.load(a)',
        'end',
      ].join("\n")
      inspect_source(source)
      expect(cop.offenses.size).to eql(1)
      expect(cop.offenses.first.message).to match(
        /`Marshal.load` on untrusted input can lead to remote code execution/
      )
    end
  end
end
