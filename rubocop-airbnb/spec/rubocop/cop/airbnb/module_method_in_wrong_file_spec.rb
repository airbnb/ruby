describe RuboCop::Cop::Airbnb::ModuleMethodInWrongFile, :config do
  let(:config) do
    RuboCop::Config.new(
      {
        "Rails" => {
          "Enabled" => true,
        },
      }
    )
  end

  # Put source in a directory under /tmp because this cop cares about the filename
  # but not the parent dir name.
  let(:tmpdir) { Dir.mktmpdir }
  let(:models_dir) do
    gemfile = File.new("#{tmpdir}/Gemfile", "w")
    gemfile.close
    FileUtils.mkdir_p("#{tmpdir}/app/models").first
  end

  after do
    FileUtils.rm_rf tmpdir
  end

  it 'rejects if module method is in file with non-matching name' do
    File.open "#{models_dir}/bar.rb", "w" do |file|
      expect_offense(<<~RUBY, file)
        module Hello
          module Foo
            def baz
            ^^^^^^^ In order for Rails autoloading to be able to find and load this file when someone calls this method, move the method definition to a file that defines the module. This file just uses the module as a namespace for another class or module. Method baz should be defined in hello/foo.rb.
              42
            end
          end
        end
      RUBY
    end
  end

  it 'accepts if module method is in file with matching name' do
    File.open "#{models_dir}/foo.rb", "w" do |file|
      expect_no_offenses(<<~RUBY, file)
        module Foo
          def baz
            42
          end
        end
      RUBY
    end
  end

  it 'rejects with "self." static methods and a non-matching name' do
    File.open "#{models_dir}/bar.rb", "w" do |file|
      expect_offense(<<~RUBY, file)
        module Foo
          def self.baz
          ^^^^^^^^^^^^ In order for Rails autoloading to be able to find and load this file when someone calls this method, move the method definition to a file that defines the module. This file just uses the module as a namespace for another class or module. Method (self) should be defined in foo.rb.
            42
          end
        end
      RUBY
    end
  end

  it 'accepts with "self." static methods and a matching name' do
    File.open "#{models_dir}/foo.rb", "w" do |file|
      expect_no_offenses(<<~RUBY, file)
        module Foo
          def self.baz
            42
          end
        end
      RUBY
    end
  end

  xit 'rejects with "<<" static methods and a non-matching name' do
    File.open "#{models_dir}/bar.rb", "w" do |file|
      expect_offense(<<~RUBY, file)
        module Foo
          class << self
            def baz
            ^^^^^^^ In order for Rails autoloading to be able to find and load this file when someone calls this method, move the method definition to a file that defines the module. This file just uses the module as a namespace for another class or module. Method baz should be defined in foo.rb.
              42
            end
          end
        end
      RUBY
    end
  end

  it 'accepts with "<<" static methods and a matching name' do
    File.open "#{models_dir}/foo.rb", "w" do |file|
      expect_no_offenses(<<~RUBY, file)
        module Foo
          class << self
            def baz
              42
            end
          end
        end
      RUBY
    end
  end

  it 'accepts methods defined in a nested class' do
    File.open "#{models_dir}/foo.rb", "w" do |file|
      expect_no_offenses(<<~RUBY, file)
        module Foo
          class Bar
            def qux
            end
          end
        end
      RUBY
    end
  end

  it 'accepts methods where the containing class uses an acronym' do
    File.open "#{models_dir}/csv_foo.rb", "w" do |file|
      expect_no_offenses(<<~RUBY, file)
        module CSVFoo
          def baz
            42
          end
        end
      RUBY
    end
  end

  it 'ignores rake tasks' do
    File.open "#{models_dir}/bar.rake", "w" do |file|
      expect_no_offenses(<<~RUBY, file)
        module Hello
          def baz
            42
          end
        end
      RUBY
    end
  end
end
