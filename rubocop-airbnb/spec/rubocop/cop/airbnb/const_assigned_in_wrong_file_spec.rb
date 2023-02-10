describe RuboCop::Cop::Airbnb::ConstAssignedInWrongFile, :config do
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

  it 'rejects if const assignment is in a file with non-matching name' do
    File.open "#{models_dir}/qux.rb", "w" do |file|
      expect_offense(<<~RUBY, file)
        module Foo
          module Bar
            BAZ = 42
            ^^^^^^^^ In order for Rails autoloading to be able to find and load this file when someone references this const, move the const assignment to a file that defines the owning module. Const BAZ should be defined in foo/bar.rb.
          end
        end
      RUBY
    end
  end

  it 'rejects if const assignment is in a file with matching name but wrong parent dir' do
    File.open "#{models_dir}/bar.rb", "w" do |file|
      expect_offense(<<~RUBY, file)
        module Foo
          module Bar
            BAZ = 42
            ^^^^^^^^ In order for Rails autoloading to be able to find and load this file when someone references this const, move the const assignment to a file that defines the owning module. Const BAZ should be defined in foo/bar.rb.
          end
        end
      RUBY
    end
  end

  it 'accepts if const assignment is in a file with matching name and right parent dir' do
    FileUtils.mkdir "#{models_dir}/foo"
    File.open "#{models_dir}/foo/bar.rb", "w" do |file|
      expect_no_offenses(<<~RUBY, file)
        module Foo
          module Bar
            BAZ = 42
          end
        end
      RUBY
    end
  end

  it 'accepts if const assignment is in a file with matching name and right parent dir' \
    'and parent modules were defined on a single line' do
    FileUtils.mkdir "#{models_dir}/foo"
    File.open "#{models_dir}/foo/bar.rb", "w" do |file|
      expect_no_offenses(<<~RUBY, file)
        module Foo::Bar
          BAZ = 42
        end
      RUBY
    end
  end

  it 'accepts if const assignment is in a file whose name matches the const and right parent dir' do
    FileUtils.mkdir_p "#{models_dir}/foo/bar"
    File.open "#{models_dir}/foo/bar/baz.rb", "w" do |file|
      expect_no_offenses(<<~RUBY, file)
        module Foo
          module Bar
            BAZ = 42
          end
        end
      RUBY
    end
  end

  it 'ignores if const assignment is assigning something in another scope' do
    File.open "#{models_dir}/foo.rb", "w" do |file|
      expect_no_offenses(<<~RUBY, file)
        module Foo
          Bar::BAZ = 42
        end
      RUBY
    end
  end

  it 'accepts const assignment where the containing class uses an acronym' do
    File.open "#{models_dir}/csv_foo.rb", "w" do |file|
      expect_no_offenses(<<~RUBY, file)
        module CSVFoo
          BAZ = 42
        end
      RUBY
    end
  end

  it 'suggests moving a global const into a namespace' do
    File.open "#{models_dir}/bar.rb", "w" do |file|
      expect_offense(<<~RUBY, file)
        FOO = 42
        ^^^^^^^^ In order for Rails autoloading to be able to find and load this file when someone references this const, move the const assignment to a file that defines the owning module. Const FOO should be moved into a namespace or defined in foo.rb.
      RUBY
    end
  end

  it 'ignores const assignment in global namespace in a rake task' do
    File.open "#{models_dir}/foo.rake", "w" do |file|
      expect_no_offenses(<<~RUBY, file)
        FOO = 42
      RUBY
    end
  end

  it 'ignores const assignment in a class in a rake task' do
    File.open "#{models_dir}/foo.rake", "w" do |file|
      expect_no_offenses(<<~RUBY, file)
        class Baz
          FOO = 42
        end
      RUBY
    end
  end
end
