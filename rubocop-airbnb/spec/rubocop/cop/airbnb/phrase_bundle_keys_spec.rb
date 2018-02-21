describe RuboCop::Cop::Airbnb::PhraseBundleKeys do
  subject(:cop) { described_class.new }

  it 'generates offenses for mismatched keys in PhraseBundle classes' do
    source = <<EOS
# encoding: UTF-8
module PhraseBundles
  class Host < PhraseBundle

    def phrases
      {
        "shortened_key" => t(
          "my_real_translation_key",
          default: 'Does not matter',
        ),
      }
    end
  end
end
EOS

    inspect_source(source)
    expect(cop.offenses.size).to eq(1)
    expect(cop.offenses.map(&:line).sort).to eq([7])
    expect(cop.messages).to eq(
      ['Phrase bundle keys should match their translation keys.']
    )
  end

  it 'does not generate offenses for matching keys in PhraseBundle classes' do
    source = <<EOS
# encoding: UTF-8
module PhraseBundles
  class Host < PhraseBundle

    def phrases
      {
        "my_real_translation_key" => t(
          "my_real_translation_key",
          default: 'Does not matter',
        ),
      }
    end
  end
end
EOS

    inspect_source(source)
    inspect_source(source)
    expect(cop.offenses).to be_empty
  end

  it 'passes on t calls that are not in PhraseBundle classes' do
    source = <<EOS
# encoding: UTF-8
module PhraseBundles
  class Host

    def phrases
      {
        "shortened_key" => t(
          "my_real_translation_key",
          default: 'Does not matter',
        ),
      }
    end
  end
end
EOS

    inspect_source(source)
    expect(cop.offenses).to be_empty
  end
end
