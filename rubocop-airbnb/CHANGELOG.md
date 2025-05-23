# 8.0.0
* [#72](https://github.com/airbnb/ruby/pull/212) Adopt Rubocop's plugin system (thanks @koic!)
* Bump minimum gem versions:
  * `rubocop` from `'~> 1.61'` to `'~> 1.72'`
  * `rubocop-performance` from `'~> 1.20'` to `'~> 1.24'`
  * `rubocop-rails` from `'~> 2.24'` to `'~> 2.30'`
  * `rubocop-rspec` from `'~> 2.26'` to `'~> 3.5'`
* Add explicit `rubocop-*` gem dependencies which have been extracted
  * `rubocop-capybara` with min version `'~> 2.22'`
  * `rubocop-factory_bot` with min version `'~> 2.27'`

# 7.0.0
* Add support for Ruby 3.3
* Drop support for Ruby 2.6
* Update rubocop to ~> 1.61

# 6.0.0
* Recover code analysis using `TargetRubyVersion` from Ruby 2.0 to 2.4
* Drop support for Ruby 2.5
* Update rubocop to ~> 1.32.0

# 5.0.0
* Add support for Ruby 3.1
* Drop support for Ruby 2.4
* Update rubocop to 1.22.0
* Update rubocop-rspec to 2.0.0
* Remove deprecated cops InvalidPredicateMatcher and CustomIncludeMethods

# 4.0.0
* Add support for Ruby 3.0
* Run CI against Ruby 2.7
* Drop support for Ruby 2.3
* Update rubocop to 0.93.1
* Update rubocop-performance to 1.10.2
* Update rubocop-rails to 2.9.1
* Update rubocop-rspec to 1.44.1
* Disable Style/BracesAroundHashParameters
* Set `DisabledByDefault: true` to disable any new rubocop cops that have not yet been evaluated for this style guide

# 3.0.2
* Moves `require`s for `rubocop-performance` and `rubocop-rails` to library code for better transitivity.

# 3.0.1
* Update supported ruby versions in gemspec

# 3.0.0
* Update to rubocop 0.76
* Enable Rails/IgnoredSkipActionFilterOption
* Enable Rails/ReflectionClassName
* Disable and delete Airbnb/ClassName
* Enable Layout/IndentFirstParameter
* Drop support for Ruby 2.2

# 2.0.0
* Upgrade to rubocop-rspec 1.30.0, use ~> to allow for PATCH version flexibility
* Upgrade to rubocop 0.58.0, use ~> to allow for PATCH version flexibility
* Enable RSpec/HooksBeforeExamples
* Enable RSpec/MissingExampleGroupArgument
* Enable RSpec/ReceiveNever
* Remove FactoryBot/DynamicAttributeDefinedStatically
* Remove FactoryBot/StaticAttributeDefinedDynamically

# 1.5.0
* Upgrade to rubocop-rspec 1.27.0
* Enable RSpec/Be
* Enable RSpec/EmptyLineAfterExampleGroup
* Enable RSpec/EmptyLineAfterHook
* Enable RSpec/SharedExamples
* Enable FactoryBot/CreateList

# 1.4.0
* Upgrade to rubocop 0.57.2

# 1.3.0
* Upgrade to rubocop 0.54.0
* Add SimpleUnless cop

# 1.0.0
* First public release of rubocop-airbnb
