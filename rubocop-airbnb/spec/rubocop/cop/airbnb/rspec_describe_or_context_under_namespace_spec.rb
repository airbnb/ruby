describe RuboCop::Cop::Airbnb::RspecDescribeOrContextUnderNamespace, :config do
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
        FileUtils.mkdir_p "#{models_spec_dir}/foo"
        File.open "#{models_spec_dir}/foo/some_class_spec.rb", "w" do |file|
          expect_offense(<<~RUBY, file)
            module Foo
            ^^^^^^^^^^ Declaring a `module` in a spec can break autoloading because subsequent references to it will not cause it to be loaded from the app. This could cause flaky tests. Remove `module Foo` and fix `Foo::CONST` and `Foo.method` calls accordingly.
              #{method} 'SomeClass' do
                it "passes" do
                  expect(true).to be_true
                end
              end
            end
          RUBY
        end
      end

      it 'rejects with change message when argument is a constant' do
        FileUtils.mkdir_p "#{models_spec_dir}/foo"
        File.open "#{models_spec_dir}/foo/some_class_spec.rb", "w" do |file|
          expect_offense(<<~RUBY, file)
            module Foo
            ^^^^^^^^^^ Declaring a `module` in a spec can break autoloading because subsequent references to it will not cause it to be loaded from the app. This could cause flaky tests. Change `#{method} SomeClass do` to `#{method} Foo::SomeClass do`. Remove `module Foo` and fix `Foo::CONST` and `Foo.method` calls accordingly.
              #{method} SomeClass do
                it "passes" do
                  expect(true).to be_true
                end
              end
            end
          RUBY
        end
      end

      it 'rejects when within a nested block' do
        FileUtils.mkdir_p "#{models_spec_dir}/foo"
        File.open "#{models_spec_dir}/foo/some_class_spec.rb", "w" do |file|
          expect_offense(<<~RUBY, file)
            module Foo
            ^^^^^^^^^^ Declaring a `module` in a spec can break autoloading because subsequent references to it will not cause it to be loaded from the app. This could cause flaky tests. Change `#{method} SomeClass do` to `#{method} Foo::SomeClass do`. Remove `module Foo` and fix `Foo::CONST` and `Foo.method` calls accordingly.
              1.times do
                #{method} SomeClass do
                  it "passes" do
                    expect(true).to be_true
                  end
                end
              end
            end
          RUBY
        end
      end

      it 'rejects when a block is executed prior' do
        FileUtils.mkdir_p "#{models_spec_dir}/foo"
        File.open "#{models_spec_dir}/foo/some_class_spec.rb", "w" do |file|
          expect_offense(<<~RUBY, file)
            module Foo
            ^^^^^^^^^^ Declaring a `module` in a spec can break autoloading because subsequent references to it will not cause it to be loaded from the app. This could cause flaky tests. Change `#{method} SomeClass do` to `#{method} Foo::SomeClass do`. Remove `module Foo` and fix `Foo::CONST` and `Foo.method` calls accordingly.
              [1,2,3].each do
                something
              end

              #{method} SomeClass do
                it "passes" do
                  expect(true).to be_true
                end
              end
            end
          RUBY
        end
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
    FileUtils.mkdir_p "#{models_spec_dir}/foo"
    File.open "#{models_spec_dir}/foo/some_class.rb", "w" do |file|
      expect_no_offenses(<<~RUBY, file)
        module Foo
          RSpec.describe "SomeClass" do
            it "passes" do
              expect(true).to be_true
            end
          end
        end
      RUBY
    end
  end

  it 'accepts if not under a module' do
    FileUtils.mkdir_p "#{models_spec_dir}/foo"
    File.open "#{models_spec_dir}/foo/some_class_spec.rb", "w" do |file|
      expect_no_offenses(<<~RUBY, file)
        RSpec.describe "SomeClass" do
          it "passes" do
            expect(true).to be_true
          end
        end
      RUBY
    end
  end

  it 'accepts if not describe or context' do
    FileUtils.mkdir_p "#{models_spec_dir}/foo"
    File.open "#{models_spec_dir}/foo/some_class_spec.rb", "w" do |file|
      expect_no_offenses(<<~RUBY, file)
        module Foo
          not_describe_or_context "SomeClass" do
            it "passes" do
              expect(true).to be_true
            end
          end
        end
      RUBY
    end
  end

  it 'accepts an empty module' do
    FileUtils.mkdir_p "#{models_spec_dir}/foo"
    File.open "#{models_spec_dir}/foo/some_class_spec.rb", "w" do |file|
      expect_no_offenses(<<~RUBY, file)
        RSpec.describe "SomeClass" do
          module Bar; end

          it "passes" do
            expect(true).to be_true
          end
        end
      RUBY
    end
  end

  it 'accepts a module with code' do
    FileUtils.mkdir_p "#{models_spec_dir}/foo"
    File.open "#{models_spec_dir}/foo/some_class_spec.rb", "w" do |file|
      expect_no_offenses(<<~RUBY, file)
        RSpec.describe "SomeClass" do
          module Bar
            def self.foo
            end
            foo
          end

          it "passes" do
            expect(true).to be_true
          end
        end
      RUBY
    end
  end

  it 'accepts when describe or context to be called when class or module is not RSpec' do
    FileUtils.mkdir_p "#{models_spec_dir}/foo"
    File.open "#{models_spec_dir}/foo/some_class_spec.rb", "w" do |file|
      expect_no_offenses(<<~RUBY, file)
        module Foo
          Bar.describe "SomeClass" do
            it "passes" do
              expect(true).to be_true
            end
          end

          Bar.context "SomeClass" do
            it "passes" do
              expect(true).to be_true
            end
          end
        end
      RUBY
    end
  end
end
