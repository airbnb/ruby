describe RuboCop::Cop::Airbnb::ContinuationSlash do
  subject(:cop) { described_class.new }

  it 'rejects continuations used to continue a method call with trailing dot' do
    source = [
      'User. \\',
      '  first_name',
    ].join("\n")
    inspect_source(source)

    expect(cop.offenses.size).to eq(1)
    expect(cop.offenses.map(&:line).sort).to eq([1])
  end

  context 'on assignment' do
    it 'rejects on constant assignment' do
      source = [
        'CONSTANT = "I am a string that \\',
        '  spans multiple lines"',
      ].join("\n")
      inspect_source(source)

      expect(cop.offenses.size).to eq(1)
    end

    it 'rejects on local variable assignment' do
      source = [
        'variable = "I am a string that \\',
        '  spans multiple lines"',
      ].join("\n")
      inspect_source(source)

      expect(cop.offenses.size).to eq(1)
    end

    it 'rejects on @var assignment' do
      source = [
        'class SomeClass',
        '  @class_var = "I am a string that \\',
        '    spans multiple lines"',
        'end',
      ].join("\n")
      inspect_source(source)

      expect(cop.offenses.size).to eq(1)
    end

    it 'rejects on @@var assignment' do
      source = [
        'class SomeClass',
        '  @@class_var = "I am a string that \\',
        '    spans multiple lines"',
        'end',
      ].join("\n")
      inspect_source(source)

      expect(cop.offenses.size).to eq(1)
    end
  end

  context 'in conditional continuation' do
    it 'rejects if with continuation \\ before operator' do
      source = [
        'if true \\',
        '   && false',
        '  return false',
        'end',
      ].join("\n")
      inspect_source(source)

      expect(cop.offenses.size).to eq(1)
    end

    it 'rejects unless with continuation \\' do
      source = [
        'unless true \\',
        '   && false',
        '  return false',
        'end',
      ].join("\n")
      inspect_source(source)

      expect(cop.offenses.size).to eq(1)
    end

    it 'rejects if with continuation \\ after operator' do
      source = [
        'if true || \\',
        '   false',
        '  return false',
        'end',
      ].join("\n")
      inspect_source(source)

      expect(cop.offenses.size).to eq(1)
    end
  end

  context 'open string continuation' do
    it 'rejects contination with space before \\' do
      source = [
        'I18n.t("I am a string that \\',
        '  spans multiple lines")',
      ].join("\n")
      inspect_source(source)

      expect(cop.offenses.size).to eq(1)
    end

    it 'rejects contination with no space before \\' do
      source = [
        'I18n.t(\'I am a string that \\',
        '  spans multiple lines\')',
      ].join("\n")
      inspect_source(source)

      expect(cop.offenses.size).to eq(1)
    end
  end

  context 'closed string continuation' do
    it 'allows double quote string with no space before \\' do
      source = [
        'I18n.t("I am a string that "\\',
        '  "spans multiple lines")',
      ].join("\n")
      inspect_source(source)

      expect(cop.offenses).to be_empty
    end

    it 'allows double quote string with space before \\' do
      source = [
        'I18n.t("I am a string that " \\',
        '  "spans multiple lines")',
      ].join("\n")
      inspect_source(source)

      expect(cop.offenses).to be_empty
    end

    it 'allows single quote string with no space before \\' do
      source = [
        'I18n.t(\'I am a string that \'\\',
        '  \'spans multiple lines\')',
      ].join("\n")
      inspect_source(source)

      expect(cop.offenses).to be_empty
    end

    it 'allows single quote string with space before \\' do
      source = [
        'I18n.t(\'I am a string that \' \\',
        '  \'spans multiple lines\')',
      ].join("\n")
      inspect_source(source)

      expect(cop.offenses).to be_empty
    end
  end
end
