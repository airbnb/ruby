describe RuboCop::Cop::Airbnb::RspecDescribeOrContextUnderNamespace do
  subject(:cop) { described_class.new }

  let(:tmpdir) { Dir.mktmpdir }
  let(:models_spec_dir) do
    FileUtils.mkdir_p("#{tmpdir}/spec/models").first
  end

  after do
    FileUtils.rm_rf tmpdir
  end

  shared_examples 'rspec namespacing rule' do
    context 'under a namespace' do
      it 'rejects without change message when argument is a string' do
        source = [
          'module Foo',
          "  #{method} 'SomeClass' do",
          '    it "passes" do',
          '      expect(true).to be_true',
          '    end',
          '  end',
          'end',
        ].join("\n")

        FileUtils.mkdir_p "#{models_spec_dir}/foo"
        File.open "#{models_spec_dir}/foo/some_class_spec.rb", "w" do |file|
          inspect_source(source, file)
        end

        expect(cop.offenses.size).to eql(1)
        expect(cop.offenses.first.message).
          to include('Declaring a `module` in a spec can break autoloading because ')

        expect(cop.offenses.first.message).
          not_to include(
            "Change `#{method} SomeClass do` to `#{method} Foo::SomeClass do`"
          )

        expect(cop.offenses.first.message).
          to include('Remove `module Foo` and fix `Foo::CONST` and `Foo.method` calls')
      end

      it 'rejects with change message when argument is a constant' do
        source = [
          'module Foo',
          "  #{method} SomeClass do",
          '    it "passes" do',
          '      expect(true).to be_true',
          '    end',
          '  end',
          'end',
        ].join("\n")

        FileUtils.mkdir_p "#{models_spec_dir}/foo"
        File.open "#{models_spec_dir}/foo/some_class_spec.rb", "w" do |file|
          inspect_source(source, file)
        end

        expect(cop.offenses.size).to eql(1)
        expect(cop.offenses.first.message).
          to include('Declaring a `module` in a spec can break autoloading because ')

        expect(cop.offenses.first.message).
          to include(
            "Change `#{method} SomeClass do` to `#{method} Foo::SomeClass do`"
          )

        expect(cop.offenses.first.message).
          to include('Remove `module Foo` and fix `Foo::CONST` and `Foo.method` calls')
      end

      it 'rejects when within a nested block' do
        source = [
          'module Foo',
          '  1.times do',
          "    #{method} SomeClass do",
          '      it "passes" do',
          '        expect(true).to be_true',
          '      end',
          '    end',
          '  end',
          'end',
        ].join("\n")

        FileUtils.mkdir_p "#{models_spec_dir}/foo"
        File.open "#{models_spec_dir}/foo/some_class_spec.rb", "w" do |file|
          inspect_source(source, file)
        end

        expect(cop.offenses.size).to eql(1)
        expect(cop.offenses.first.message).
          to include('Declaring a `module` in a spec can break autoloading because ')

        expect(cop.offenses.first.message).
          to include(
            "Change `#{method} SomeClass do` to `#{method} Foo::SomeClass do`"
          )

        expect(cop.offenses.first.message).
          to include('Remove `module Foo` and fix `Foo::CONST` and `Foo.method` calls')
      end

      it 'rejects when a block is executed prior' do
        source = [
          'module Foo',
          '  [1,2,3].each do',
          '    something',
          '  end',
          '',
          "  #{method} SomeClass do",
          '    it "passes" do',
          '      expect(true).to be_true',
          '    end',
          '  end',
          'end',
        ].join("\n")

        FileUtils.mkdir_p "#{models_spec_dir}/foo"
        File.open "#{models_spec_dir}/foo/some_class_spec.rb", "w" do |file|
          inspect_source(source, file)
        end

        expect(cop.offenses.size).to eql(1)
        expect(cop.offenses.first.message).
          to include('Declaring a `module` in a spec can break autoloading because ')

        expect(cop.offenses.first.message).
          to include(
            "Change `#{method} SomeClass do` to `#{method} Foo::SomeClass do`"
          )

        expect(cop.offenses.first.message).
          to include('Remove `module Foo` and fix `Foo::CONST` and `Foo.method` calls')
      end
    end
  end

  context 'describe' do
    let!(:method) { 'describe' }

    it_behaves_like 'rspec namespacing rule'
  end

  context 'RSpec.describe' do
    let!(:method) { 'RSpec.describe' }

    it_behaves_like 'rspec namespacing rule'
  end

  context 'context' do
    let!(:method) { 'context' }

    it_behaves_like 'rspec namespacing rule'
  end

  context 'RSpec.context' do
    let!(:method) { 'RSpec.context' }

    it_behaves_like 'rspec namespacing rule'
  end

  it 'accepts if file is not a spec file' do
    source = [
      'module Foo',
      '  RSpec.describe "SomeClass" do',
      '    it "passes" do',
      '      expect(true).to be_true',
      '    end',
      '  end',
      'end',
    ].join("\n")

    FileUtils.mkdir_p "#{models_spec_dir}/foo"
    File.open "#{models_spec_dir}/foo/some_class.rb", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses).to be_empty
  end

  it 'accepts if not under a module' do
    source = [
      'RSpec.describe "SomeClass" do',
      '  it "passes" do',
      '    expect(true).to be_true',
      '  end',
      'end',
    ].join("\n")

    FileUtils.mkdir_p "#{models_spec_dir}/foo"
    File.open "#{models_spec_dir}/foo/some_class_spec.rb", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses).to be_empty
  end

  it 'accepts if not describe or context' do
    source = [
      'module Foo',
      '  not_describe_or_context "SomeClass" do',
      '    it "passes" do',
      '      expect(true).to be_true',
      '    end',
      '  end',
      'end',
    ].join("\n")

    FileUtils.mkdir_p "#{models_spec_dir}/foo"
    File.open "#{models_spec_dir}/foo/some_class_spec.rb", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses).to be_empty
  end

  it 'accepts an empty module' do
    source = [
      'RSpec.describe "SomeClass" do',
      '  module Bar; end',
      '',
      '  it "passes" do',
      '    expect(true).to be_true',
      '  end',
      'end',
    ].join("\n")

    FileUtils.mkdir_p "#{models_spec_dir}/foo"
    File.open "#{models_spec_dir}/foo/some_class_spec.rb", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses).to be_empty
  end

  it 'accepts a module with code' do
    source = [
      'RSpec.describe "SomeClass" do',
      '  module Bar',
      '    def self.foo',
      '    end',
      '    foo',
      '  end',
      '',
      '  it "passes" do',
      '    expect(true).to be_true',
      '  end',
      'end',
    ].join("\n")

    FileUtils.mkdir_p "#{models_spec_dir}/foo"
    File.open "#{models_spec_dir}/foo/some_class_spec.rb", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses).to be_empty
  end

  it 'accepts when describe or context to be called when class or module is not RSpec' do
    source = [
      'module Foo',
      '  Bar.describe "SomeClass" do',
      '    it "passes" do',
      '      expect(true).to be_true',
      '    end',
      '  end',
      '',
      '  Bar.context "SomeClass" do',
      '    it "passes" do',
      '      expect(true).to be_true',
      '    end',
      '  end',
      'end',
    ].join("\n")

    FileUtils.mkdir_p "#{models_spec_dir}/foo"
    File.open "#{models_spec_dir}/foo/some_class_spec.rb", "w" do |file|
      inspect_source(source, file)
    end

    expect(cop.offenses).to be_empty
  end
end
