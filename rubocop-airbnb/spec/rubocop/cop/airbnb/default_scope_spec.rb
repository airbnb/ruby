describe RuboCop::Cop::Airbnb::DefaultScope do
  subject(:cop) { described_class.new }

  it 'rejects with default_scopes' do
    source = [
      '# encoding: UTF-8',
      'module SurveyQuestion',
      '  class Host < PhraseBundle',
      '    db_magic :connection => AIRMISC_MASTER,',
      '             :slaves => AIRMISC_DB_SLAVES,',
      '             :force_slave_reads => FORCE_SLAVE_READS',
      '',
      '    default_scope where(active: true)',
      '',
      '  end',
      'end',
    ].join("\n")
    inspect_source(source)

    expect(cop.offenses.size).to eq(1)
    expect(cop.offenses.map(&:line).sort).to eq([8])
  end

  it 'passes when there is no default_scope' do
    source = [
      '# encoding: UTF-8',
      'module SurveyQuestion',
      '  class Host < PhraseBundle',
      '    db_magic :connection => AIRMISC_MASTER,',
      '             :slaves => AIRMISC_DB_SLAVES,',
      '             :force_slave_reads => FORCE_SLAVE_READS',
      '  end',
      'end',
    ].join("\n")
    inspect_source(source)
    expect(cop.offenses).to be_empty
  end
end
