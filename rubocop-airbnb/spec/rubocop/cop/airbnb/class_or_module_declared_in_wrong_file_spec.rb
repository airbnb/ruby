describe RuboCop::Cop::Airbnb::ClassOrModuleDeclaredInWrongFile, :config do
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

  it 'rejects if class declaration is in a file with non-matching name' do
    File.open "#{models_dir}/qux.rb", "w" do |file|
      expect_offense(<<~RUBY, file)
        module Foo
        ^^^^^^^^^^ In order for Rails autoloading to be able to find and load this file when someone references this class/module, move its definition to a file that matches its name. Module Foo should be defined in foo.rb.
          module Bar
          ^^^^^^^^^^ In order for Rails autoloading [...]
            class Baz
            ^^^^^^^^^ In order for Rails autoloading [...]
            end
          end
        end
      RUBY
    end
  end

  it 'rejects if class declaration is in a file with matching name but wrong parent dir' do
    File.open "#{models_dir}/baz.rb", "w" do |file|
      expect_offense(<<~RUBY, file)
        module Foo
        ^^^^^^^^^^ In order for Rails autoloading [...]
          module Bar
          ^^^^^^^^^^ In order for Rails autoloading [...]
            class Baz
            ^^^^^^^^^ In order for Rails autoloading to be able to find and load this file when someone references this class/module, move its definition to a file that matches its name. Class Baz should be defined in foo/bar/baz.rb.
            end
          end
        end
      RUBY
    end
  end

  it 'accepts if class declaration is in a file with matching name and right parent dir' do
    FileUtils.mkdir_p "#{models_dir}/foo/bar"
    File.open "#{models_dir}/foo/bar/baz.rb", "w" do |file|
      expect_no_offenses(<<~RUBY, file)
        module Foo
          module Bar
            class Baz
            end
          end
        end
      RUBY
    end
  end

  it 'rejects if class declaration is in wrong dir and parent module uses ::' do
    FileUtils.mkdir_p "#{models_dir}/bar"
    File.open "#{models_dir}/bar/baz.rb", "w" do |file|
      expect_offense(<<~RUBY, file)
        module Foo::Bar
        ^^^^^^^^^^^^^^^ In order for Rails autoloading [...]
          class Baz
          ^^^^^^^^^ In order for Rails autoloading to be able to find and load this file when someone references this class/module, move its definition to a file that matches its name. Class Baz should be defined in foo/bar/baz.rb.
          end
        end
      RUBY
    end
  end

  it 'accepts if class declaration is in a file with matching name and parent module uses ::' do
    FileUtils.mkdir_p "#{models_dir}/foo/bar"
    File.open "#{models_dir}/foo/bar/baz.rb", "w" do |file|
      expect_no_offenses(<<~RUBY, file)
        module Foo::Bar
          class Baz
          end
        end
      RUBY
    end
  end

  it 'accepts class declaration where the containing class uses an acronym' do
    FileUtils.mkdir_p "#{models_dir}/csv_foo"
    File.open "#{models_dir}/csv_foo/baz.rb", "w" do |file|
      expect_no_offenses(<<~RUBY)
        module CSVFoo
          class Baz
          end
        end
      RUBY
    end
  end

  it 'ignores class/module declaration in a rake task' do
    File.open "#{models_dir}/foo.rake", "w" do |file|
      expect_no_offenses(<<~RUBY, file)
        class Baz
        end
      RUBY
    end
  end

  it 'suggests moving error classes into the file that defines the owning scope' do
    File.open "#{models_dir}/bar.rb", "w" do |file|
      expect_offense(<<~RUBY, file)
        module Foo
        ^^^^^^^^^^ In order for Rails autoloading [...]
          class BarError < StandardError; end
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ In order for Rails autoloading to be able to find and load this file when someone references this class, move its definition to a file that defines the owning module. Class BarError should be defined in foo.rb.
        end
      RUBY
    end
  end

  it 'recognizes error class based on the superclass name' do
    File.open "#{models_dir}/bar.rb", "w" do |file|
      expect_offense(<<~RUBY, file)
        module Foo
        ^^^^^^^^^^ In order for Rails autoloading [...]
          class Bar < StandardError; end
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ In order for Rails autoloading to be able to find and load this file when someone references this class, move its definition to a file that defines the owning module. Class Bar should be defined in foo.rb.
        end
      RUBY
    end
  end
end
