describe RuboCop::Cop::Airbnb::DefaultScope, :config do
  it 'rejects with default_scopes' do
    expect_offense(<<~RUBY)
      # encoding: UTF-8
      module SurveyQuestion
        class Host < PhraseBundle
          db_magic :connection => AIRMISC_MASTER,
                   :slaves => AIRMISC_DB_SLAVES,
                   :force_slave_reads => FORCE_SLAVE_READS

          default_scope where(active: true)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid `default_scope`. [...]

        end
      end
    RUBY
  end

  it 'passes when there is no default_scope' do
    expect_no_offenses(<<~RUBY)
      # encoding: UTF-8
      module SurveyQuestion
        class Host < PhraseBundle
          db_magic :connection => AIRMISC_MASTER,
                   :slaves => AIRMISC_DB_SLAVES,
                   :force_slave_reads => FORCE_SLAVE_READS
        end
      end
    RUBY
  end
end
