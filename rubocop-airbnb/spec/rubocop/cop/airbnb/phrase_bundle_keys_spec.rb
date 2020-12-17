describe RuboCop::Cop::Airbnb::PhraseBundleKeys, :config do
  it 'generates offenses for mismatched keys in PhraseBundle classes' do
    expect_offense(<<EOS)
# encoding: UTF-8
module PhraseBundles
  class Host < PhraseBundle

    def phrases
      {
        "shortened_key" => t(
        ^^^^^^^^^^^^^^^ Phrase bundle keys should match their translation keys.
          "my_real_translation_key",
          default: 'Does not matter',
        ),
      }
    end
  end
end
EOS
  end

  it 'does not generate offenses for matching keys in PhraseBundle classes' do
    expect_no_offenses(<<EOS)
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
  end

  it 'passes on t calls that are not in PhraseBundle classes' do
    expect_no_offenses(<<EOS)
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
  end
end
