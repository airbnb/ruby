describe RuboCop::Cop::Airbnb::ModuleMethodInWrongFile do
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

  it 'rejects if module method is in file with non-matching name' do
    source = [
      'module Hello',
      '  module Foo',
      '    def baz', # error is here if this file is named bar.rb
      '      42',
      '    end',
      '  end',
      'end',
    ].join("\n")

    File.open "#{models_dir}/bar.rb", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses.size).to eq(1)
    expect(cop.offenses.map(&:line).sort).to eq([3])
    expect(cop.offenses.first.message).to include("Method baz should be defined in hello/foo.rb.")
  end

  it 'accepts if module method is in file with matching name' do
    source = [
      'module Foo',
      '  def baz',
      '    42',
      '  end',
      'end',
    ].join("\n")

    File.open "#{models_dir}/foo.rb", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses).to be_empty
  end

  it 'rejects with "self." static methods and a non-matching name' do
    source = [
      'module Foo',
      '  def self.baz',
      '    42',
      '  end',
      'end',
    ].join("\n")

    File.open "#{models_dir}/bar.rb", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses.size).to eq(1)
    expect(cop.offenses.map(&:line).sort).to eq([2])
  end

  it 'accepts with "self." static methods and a matching name' do
    source = [
      'module Foo',
      '  def self.baz',
      '    42',
      '  end',
      'end',
    ].join("\n")

    File.open "#{models_dir}/foo.rb", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses).to be_empty
  end

  it 'rejects with "<<" static methods and a non-matching name' do
    source = [
      'module Foo',
      '  class << self',
      '    def baz',
      '      42',
      '    end',
      '  end',
      'end',
    ].join("\n")

    File.open "#{models_dir}/bar.rb", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses.size).to eq(1)
    expect(cop.offenses.map(&:line).sort).to eq([3])
  end

  it 'accepts with "<<" static methods and a matching name' do
    source = [
      'module Foo',
      '  class << self',
      '    def baz',
      '      42',
      '    end',
      '  end',
      'end',
    ].join("\n")

    File.open "#{models_dir}/foo.rb", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses).to be_empty
  end

  it 'accepts methods defined in a nested class' do
    source = [
      'module Foo',
      '  class Bar',
      '    def qux',
      '    end',
      '  end',
      'end',
    ].join("\n")

    File.open "#{models_dir}/foo.rb", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses).to be_empty
  end

  it 'accepts methods where the containing class uses an acronym' do
    source = [
      'module CSVFoo',
      '  def baz',
      '    42',
      '  end',
      'end',
    ].join("\n")

    File.open "#{models_dir}/csv_foo.rb", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses).to be_empty
  end

  it 'ignores rake tasks' do
    source = [
      'module Hello',
      '  def baz', # error is here if this file is named bar.rb
      '    42',
      '  end',
      'end',
    ].join("\n")

    File.open "#{models_dir}/bar.rake", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses).to be_empty
  end
end
