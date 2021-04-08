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
