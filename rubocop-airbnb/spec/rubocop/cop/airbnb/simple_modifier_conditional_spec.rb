describe RuboCop::Cop::Airbnb::SimpleModifierConditional do
  subject(:cop) { described_class.new }

  context 'multiple conditionals' do
    it 'rejects with modifier if with multiple conditionals' do
      source = [
        'return true if some_method == 0 || another_method',
      ].join("\n")

      inspect_source(source)
      expect(cop.offenses.size).to eq(1)
    end

    it 'rejects with modifier unless with multiple conditionals' do
      source = [
        'return true unless true && false',
      ].join("\n")

      inspect_source(source)
      expect(cop.offenses.size).to eq(1)
    end

    it 'allows with modifier if operator conditional' do
      source = [
        'return true if some_method == 0',
      ].join("\n")

      inspect_source(source)
      expect(cop.offenses).to be_empty
    end

    it 'allows with modifier if with single conditional' do
      source = [
        'return true if some_method == 0',
        'return true if another_method',
      ].join("\n")

      inspect_source(source)
      expect(cop.offenses).to be_empty
    end

    it 'allows with modifier if and unless with single conditional ' do
      source = [
        'return true if some_method',
        'return true unless another_method > 5',
      ].join("\n")

      inspect_source(source)
      expect(cop.offenses).to be_empty
    end

    it 'allows multiple conditionals in block form' do
      source = [
        'if some_method == 0 && another_method > 5 || true || false',
        ' return true',
        'end',
      ].join("\n")

      inspect_source(source)
      expect(cop.offenses).to be_empty
    end
  end

  context 'multiple lines' do
    it 'rejects modifier conditionals that span multiple lines' do
      source = [
        'return true if true ||',
        '               false',
        'return true unless true ||',
        '                   false',
      ].join("\n")

      inspect_source(source)
      expect(cop.offenses.size).to eq(2)
    end

    it 'rejects with modifier if with method that spans multiple lines' do
      source = [
        'return true if some_method(param1,',
        '                           param2,',
        '                           param3)',
        'return true unless some_method(param1,',
        '                               param2,',
        '                               param3)',
      ].join("\n")

      inspect_source(source)
      expect(cop.offenses.size).to eq(2)
    end

    it 'rejects inline if/unless after a multiline statement' do
      source = [
        'return some_method(',
        '  param1,',
        '  param2,',
        '  param3',
        ') if another_method == 0',
        'return some_method(',
        '  param1,',
        '  param2,',
        '  param3',
        ') unless another_method == 0',
      ].join("\n")

      inspect_source(source)
      expect(cop.offenses.size).to eq(2)
    end

    it 'allows multline conditionals in block form' do
      source = [
        'if some_method(param1,',
        '               param2,',
        '               parma3)',
        ' return true',
        'end',
      ].join("\n")

      inspect_source(source)
      expect(cop.offenses).to be_empty
    end
  end
end
