describe RuboCop::Cop::Airbnb::ConstAssignedInWrongFile do
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

  it 'rejects if const assignment is in a file with non-matching name' do
    source = [
      'module Foo',
      '  module Bar',
      '    BAZ = 42',
      '  end',
      'end',
    ].join("\n")

    File.open "#{models_dir}/qux.rb", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses.map(&:line)).to include(3)
    expect(cop.offenses.map(&:message)).to include(%r{Const BAZ should be defined in foo/bar\.rb.})
  end

  it 'rejects if const assignment is in a file with matching name but wrong parent dir' do
    source = [
      'module Foo',
      '  module Bar',
      '    BAZ = 42',
      '  end',
      'end',
    ].join("\n")

    File.open "#{models_dir}/bar.rb", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses.map(&:line)).to include(3)
    expect(cop.offenses.map(&:message)).to include(%r{Const BAZ should be defined in foo/bar\.rb.})
  end

  it 'accepts if const assignment is in a file with matching name and right parent dir' do
    source = [
      'module Foo',
      '  module Bar',
      '    BAZ = 42',
      '  end',
      'end',
    ].join("\n")

    FileUtils.mkdir "#{models_dir}/foo"
    File.open "#{models_dir}/foo/bar.rb", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses).to be_empty
  end

  it 'accepts if const assignment is in a file with matching name and right parent dir' \
    'and parent modules were defined on a single line' do
    source = [
      'module Foo::Bar',
      '  BAZ = 42',
      'end',
    ].join("\n")

    FileUtils.mkdir "#{models_dir}/foo"
    File.open "#{models_dir}/foo/bar.rb", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses).to be_empty
  end

  it 'accepts if const assignment is in a file whose name matches the const and right parent dir' do
    source = [
      'module Foo',
      '  module Bar',
      '    BAZ = 42',
      '  end',
      'end',
    ].join("\n")

    FileUtils.mkdir_p "#{models_dir}/foo/bar"
    File.open "#{models_dir}/foo/bar/baz.rb", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses).to be_empty
  end

  it 'ignores if const assignment is assigning something in another scope' do
    source = [
      'module Foo',
      '  Bar::BAZ = 42',
      'end',
    ].join("\n")

    File.open "#{models_dir}/foo.rb", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses).to be_empty
  end

  it 'accepts const assignment where the containing class uses an acronym' do
    source = [
      'module CSVFoo',
      '  BAZ = 42',
      'end',
    ].join("\n")

    File.open "#{models_dir}/csv_foo.rb", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses).to be_empty
  end

  it 'suggests moving a global const into a namespace' do
    source = [
      'FOO = 42',
    ].join("\n")

    File.open "#{models_dir}/bar.rb", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses.map(&:line)).to eq([1])
    expect(cop.offenses.first.message).
      to include('Const FOO should be moved into a namespace or defined in foo.rb.')
  end

  it 'ignores const assignment in global namespace in a rake task' do
    source = [
      'FOO = 42',
    ].join("\n")

    File.open "#{models_dir}/foo.rake", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses).to be_empty
  end

  it 'ignores const assignment in a class in a rake task' do
    source = [
      'class Baz',
      '  FOO = 42',
      'end',
    ].join("\n")

    File.open "#{models_dir}/foo.rake", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses).to be_empty
  end
end
