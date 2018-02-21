describe RuboCop::Cop::Airbnb::ClassOrModuleDeclaredInWrongFile do
  subject(:cop) { described_class.new(config) }

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
    source = [
      'module Foo',
      '  module Bar',
      '    class Baz',
      '    end',
      '  end',
      'end',
    ].join("\n")

    File.open "#{models_dir}/qux.rb", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses.size).to eq(3)
    expect(cop.offenses.map(&:line).sort).to eq([1, 2, 3])
    expect(cop.offenses.first.message).to include('Module Foo should be defined in foo.rb.')
  end

  it 'rejects if class declaration is in a file with matching name but wrong parent dir' do
    source = [
      'module Foo',
      '  module Bar',
      '    class Baz',
      '    end',
      '  end',
      'end',
    ].join("\n")

    File.open "#{models_dir}/baz.rb", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses.size).to eq(3)
    expect(cop.offenses.map(&:line).sort).to eq([1, 2, 3])
    expect(cop.offenses.last.message).to include('Class Baz should be defined in foo/bar/baz.rb.')
  end

  it 'accepts if class declaration is in a file with matching name and right parent dir' do
    source = [
      'module Foo',
      '  module Bar',
      '    class Baz',
      '    end',
      '  end',
      'end',
    ].join("\n")

    FileUtils.mkdir_p "#{models_dir}/foo/bar"
    File.open "#{models_dir}/foo/bar/baz.rb", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses).to be_empty
  end

  it 'rejects if class declaration is in wrong dir and parent module uses ::' do
    source = [
      'module Foo::Bar',
      '  class Baz',
      '  end',
      'end',
    ].join("\n")

    FileUtils.mkdir_p "#{models_dir}/bar"
    File.open "#{models_dir}/bar/baz.rb", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses.map(&:line).sort).to eq([1, 2])
    expect(cop.offenses.last.message).to include('Class Baz should be defined in foo/bar/baz.rb.')
  end

  it 'accepts if class declaration is in a file with matching name and parent module uses ::' do
    source = [
      'module Foo::Bar',
      '  class Baz',
      '  end',
      'end',
    ].join("\n")

    FileUtils.mkdir_p "#{models_dir}/foo/bar"
    File.open "#{models_dir}/foo/bar/baz.rb", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses).to be_empty
  end

  it 'accepts class declaration where the containing class uses an acronym' do
    source = [
      'module CSVFoo',
      '  class Baz',
      '  end',
      'end',
    ].join("\n")

    FileUtils.mkdir_p "#{models_dir}/csv_foo"
    File.open "#{models_dir}/csv_foo/baz.rb", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses).to be_empty
  end

  it 'ignores class/module declaration in a rake task' do
    source = [
      'class Baz',
      'end',
    ].join("\n")

    File.open "#{models_dir}/foo.rake", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses).to be_empty
  end

  it 'suggests moving error classes into the file that defines the owning scope' do
    source = [
      'module Foo',
      '  class BarError < StandardError; end',
      'end',
    ].join("\n")

    File.open "#{models_dir}/bar.rb", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses.map(&:line)).to include(2)
    expect(cop.offenses.map(&:message)).to include(%r{Class BarError should be defined in foo\.rb.})
  end

  it 'recognizes error class based on the superclass name' do
    source = [
      'module Foo',
      '  class Bar < StandardError; end',
      'end',
    ].join("\n")

    File.open "#{models_dir}/bar.rb", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses.map(&:line)).to include(2)
    expect(cop.offenses.map(&:message)).to include(%r{Class Bar should be defined in foo\.rb.})
  end
end
