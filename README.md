# Ruby Style Guide

This is Crowdtap's Ruby Style Guide.

It was inspired by Airbnb's styleguide.

## Table of Contents
  1. [Whitespace](#whitespace)
    1. [Indentation](#indentation)
    1. [Inline](#inline)
    1. [Newlines](#newlines)
    1. [Blocks](#blocks)
  1. [Line Length](#line-length)
  1. [Commenting](#commenting)
    1. [File/class-level comments](#fileclass-level-comments)
    1. [Function comments](#function-comments)
    1. [Block and inline comments](#block-and-inline-comments)
    1. [Punctuation, spelling, and grammar](#punctuation-spelling-and-grammar)
    1. [TODO comments](#todo-comments)
    1. [Commented-out code](#commented-out-code)
  1. [Methods](#methods)
    1. [Method definitions](#method-definitions)
    1. [Method calls](#method-calls)
  1. [Conditional Expressions](#conditional-expressions)
    1. [Conditional keywords](#conditional-keywords)
    1. [Ternary operator](#ternary-operator)
  1. [Syntax](#syntax)
  1. [Naming](#naming)
  1. [Classes](#classes)
  1. [Exceptions](#exceptions)
  1. [Collections](#collections)
  1. [Strings](#strings)
  1. [Regular Expressions](#regular-expressions)
  1. [Percent Literals](#percent-literals)
  1. [Rails](#rails)
    1. [Scopes](#scopes)
  1. [Be Consistent](#be-consistent)

## Whitespace

### Indentation

* <a name="default-indentation"></a>Use soft-tabs with a two
    space-indent.<sup>[[link](#default-indentation)]</sup>

* <a name="indent-when-as-case"></a>Indent `when` as deep as `case`.
    <sup>[[link](#indent-when-as-case)]</sup>

    ```ruby
    case
    when song.name == 'Misty'
      puts 'Not again!'
    when song.duration > 120
      puts 'Too long!'
    when Time.now.hour > 21
      puts "It's too late"
    else
      song.play
    end

    kind = case year
           when 1850..1889 then 'Blues'
           when 1890..1909 then 'Ragtime'
           when 1910..1929 then 'New Orleans Jazz'
           when 1930..1939 then 'Swing'
           when 1940..1950 then 'Bebop'
           else 'Jazz'
           end
    ```

* <a name="align-function-params"></a>Align function parameters either all on
    the same line or one per line.<sup>[[link](#align-function-params)]</sup>

    ```ruby
    # good
    def self.create_translation(phrase_id,
                                phrase_key,
                                target_locale,
                                value,
                                user_id,
                                do_xss_check,
                                allow_verification)
      ...
    end

    # good
    def self.create_translation(
      phrase_id,
      phrase_key,
      target_locale,
      value,
      user_id,
      do_xss_check,
      allow_verification
    )
      ...
    end

    # bad
    def self.create_translation(phrase_id, phrase_key, target_locale,
                                value, user_id, do_xss_check, allow_verification)
      ...
    end
    ```

* <a name="indent-multi-line-bool"></a>Indent succeeding lines in multi-line
    boolean expressions.<sup>[[link](#indent-multi-line-bool)]</sup>

    ```ruby
    # good
    def is_eligible?(user)
      Trebuchet.current.launch?(ProgramEligibilityHelper::PROGRAM_TREBUCHET_FLAG) &&
        is_in_program?(user) &&
        program_not_expired
    end

    # bad
    def is_eligible?(user)
      Trebuchet.current.launch?(ProgramEligibilityHelper::PROGRAM_TREBUCHET_FLAG) &&
      is_in_program?(user) &&
      program_not_expired
    end
    ```

### Inline

* <a name="trailing-whitespace"></a>Never leave trailing whitespace.
    <sup>[[link](#trailing-whitespace)]</sup>

* <a name="spaces-operators"></a>Use spaces around operators; after commas,
    colons, and semicolons; and around `{` and before `}`.
    <sup>[[link](#spaces-operators)]</sup>

    ```ruby
    sum = 1 + 2
    a, b = 1, 2
    1 > 2 ? true : false; puts 'Hi'
    [1, 2, 3].each { |e| puts e }
    ```

* <a name="no-spaces-braces"></a>No spaces after `(`, `[` or before `]`, `)`.
    <sup>[[link](#no-spaces-braces)]</sup>

    ```ruby
    some(arg).other
    [1, 2, 3].length
    ```

### Newlines

* <a name="multiline-if-newline"></a>Add a new line after `if` conditions span
    multiple lines to help differentiate between the conditions and the body.
    <sup>[[link](#multiline-if-newline)]</sup>

    ```ruby
    if @reservation_alteration.checkin == @reservation.start_date &&
       @reservation_alteration.checkout == (@reservation.start_date + @reservation.nights)

      redirect_to_alteration @reservation_alteration
    end
    ```

* <a name="newline-after-conditional"></a>Add a new line after conditionals,
    blocks, case statements, etc.<sup>[[link](#newline-after-conditional)]</sup>

    ```ruby
    if robot.is_awesome?
      send_robot_present
    end

    robot.add_trait(:human_like_intelligence)
    ```

### Blocks
* <a name="rspec-let"></a>Add new lines in any block definitions
    if they are too long

    ```ruby
    # bad
    scope :where_name_like, lambda {|name| any_of({ :name => /#{Regexp.quote(name)}/i },  { :short_name => /#{Regexp.quote(name)}/i } )}

    # bad
    scope :where_name_like, lambda { |name|
      any_of({ :name => /#{Regexp.quote(name)}/i },
             { :short_name => /#{Regexp.quote(name)}/i } )
    }

    # bad
    let(:brand) { create(:brand, :name => "Hello", :subscription => create(:ready_to_start_subscription, :days_paid => 10), :clients => [create(:client), create(:client)]) }

    # good
    scope :where_name_like, -> do |name|
      any_of(
        { :name => /#{Regexp.quote(name)}/i },
        { :short_name => /#{Regexp.quote(name)}/i }
      )
    end

    # good
    let(:brand) do
      create(
        :brand,
        :name => "Hello",
        :subscription => subscription,
        :clients => [client_1, client_2]
      )
    end
    let(:subscription) { create(:ready_to_start_subscription, :days_paid => 20) }
    let(:client_1) { create(:client) }
    let(:client21) { create(:client) }
    ```

## Line Length

* Keep each line of code to a readable length. Unless
  you have a reason to, keep lines to fewer than 100 characters.
  ([rationale](./rationales.md#line-length))<sup>
  [[link](#line-length)]</sup>

## Commenting
> Good code is its own best documentation. As you're about to add a
> comment, ask yourself, "How can I improve the code so that this
> comment isn't needed?" Improve the code and then document it to make
> it even clearer. <br/>
> -- Steve McConnell

* Write self-documenting code and ignore the rest of this section. Seriously!
* Avoid superfluous comments.

```Ruby
  # bad
  counter += 1 # increments counter by one
```

* Keep existing comments up-to-date or attempt to delete them with good code.
  An outdated is worse than no comment at all.

> Good code is like a good joke - it needs no explanation.
> <br/>
> -- Russ Olsen

* Avoid writing comments to explain bad code. Refactor the code to make it self-explanatory.
> Try not! Do or do not - there is no try.
> <br/>
> --Yoda

### TODO comments

Use TODO comments for code that is temporary, a short-term solution, or
good-enough but not perfect.

TODOs should include the string TODO in all caps, followed by the full name
of the person who can best provide context about the problem referenced by the
TODO, in parentheses. A colon is optional. A comment explaining what there is
to do is required. The main purpose is to have a consistent TODO format that
can be searched to find the person who can provide more details upon request.
A TODO is not a commitment that the person referenced will fix the problem.
Thus when you create a TODO, it is almost always your name that is given.

```ruby
  # bad
  # TODO(RS): Use proper namespacing for this constant.

  # bad
  # TODO(drumm3rz4lyfe): Use proper namespacing for this constant.

  # good
  # TODO(Ringo Starr): Use proper namespacing for this constant.
```

### Commented-out code

* <a name="commented-code"></a>Never leave commented-out code in our codebase.
    <sup>[[link](#commented-code)]</sup>

## Methods

### Method definitions

* <a name="method-def-parens"></a>Use `def` with parentheses when there are
    parameters. Omit the parentheses when the method doesn't accept any
    parameters.<sup>[[link](#method-def-parens)]</sup>

     ```ruby
     def some_method
       # body omitted
     end

     def some_method_with_parameters(arg1, arg2)
       # body omitted
     end
     ```

* <a name="no-default-args"></a>Do not use default arguments. Use an options
    hash instead.<sup>[[link](#no-default-args)]</sup>

    ```ruby
    # bad
    def obliterate(things, gently = true, except = [], at = Time.now)
      ...
    end

    # good
    def obliterate(things, options = {})
      default_options = {
        :gently => true, # obliterate with soft-delete
        :except => [], # skip obliterating these things
        :at => Time.now, # don't obliterate them until later
      }
      options.reverse_merge!(default_options)

      ...
    end
    ```

### Method calls

**Use parentheses** for a method call:

* <a name="returns-val-parens"></a>If the method returns a value.
    <sup>[[link](#returns-val-parens)]</sup>

    ```ruby
    # bad
    @current_user = User.find_by_id 1964192

    # good
    @current_user = User.find_by_id(1964192)
    ```

* <a name="first-arg-parens"></a>If the first argument to the method uses
    parentheses.<sup>[[link](#first-arg-parens)]</sup>

    ```ruby
    # bad
    put! (x + y) % len, value

    # good
    put!((x + y) % len, value)
    ```

* <a name="space-method-call"></a>Never put a space between a method name and
    the opening parenthesis.<sup>[[link](#space-method-call)]</sup>

    ```ruby
    # bad
    f (3 + 2) + 1

    # good
    f(3 + 2) + 1
    ```

* <a name="no-args-parens"></a>**Omit parentheses** for a method call if the
    method accepts no arguments.<sup>[[link](#no-args-parens)]</sup>

    ```ruby
    # bad
    nil?()

    # good
    nil?
    ```

* <a name="no-return-parens"></a>If the method doesn't return a value (or we
    don't care about the return), parentheses are optional. (Especially if the
    arguments overflow to multiple lines, parentheses may add readability.)
    <sup>[[link](#no-return-parens)]</sup>

    ```ruby
    # okay
    render(:partial => 'foo')

    # okay
    render :partial => 'foo'
    ```

In either case:

* <a name="options-no-braces"></a>If a method accepts an options hash as the
    last argument, do not use `{` `}` during invocation.
    <sup>[[link](#options-no-braces)]</sup>

    ```ruby
    # bad
    get '/v1/reservations', { :id => 54875 }

    # good
    get '/v1/reservations', :id => 54875
    ```

## Conditional Expressions

### Conditional keywords

* <a name="multiline-if-then"></a>Never use `then` for multi-line `if/unless`.
    <sup>[[link](#multiline-if-then)]</sup>

    ```ruby
    # bad
    if some_condition then
      ...
    end

    # good
    if some_condition
      ...
    end
    ```

* <a name="no-and-or"></a>The `and`, `or`, and `not` keywords are banned. It's
    just not worth it. Always use `&&`, `||`, and `!` instead.
    <sup>[[link](#no-and-or)]</sup>

* <a name="only-simple-if-unless"></a>Modifier `if/unless` usage is okay when
    the body is simple, the condition is simple, and the whole thing fits on
    one line. Otherwise, avoid modifier `if/unless`.
    <sup>[[link](#only-simple-if-unless)]</sup>

    ```ruby
    # bad - this doesn't fit on one line
    add_trebuchet_experiments_on_page(request_opts[:trebuchet_experiments_on_page]) if request_opts[:trebuchet_experiments_on_page] && !request_opts[:trebuchet_experiments_on_page].empty?

    # okay
    if request_opts[:trebuchet_experiments_on_page] &&
         !request_opts[:trebuchet_experiments_on_page].empty?

      add_trebuchet_experiments_on_page(request_opts[:trebuchet_experiments_on_page])
    end

    # bad - this is complex and deserves multiple lines and a comment
    parts[i] = part.to_i(INTEGER_BASE) if !part.nil? && [0, 2, 3].include?(i)

    # okay
    return if reconciled?
    ```

* <a name="no-unless-with-else"></a>Never use `unless` with `else`. Rewrite
    these with the positive case first.<sup>[[link](#no-unless-with-else)]</sup>

    ```ruby
    # bad
    unless success?
      puts 'failure'
    else
      puts 'success'
    end

    # good
    if success?
      puts 'success'
    else
      puts 'failure'
    end
    ```

* <a name="unless-with-multiple-conditions"></a>Avoid `unless` with multiple
    conditions.<sup>[[link](#unless-with-multiple-conditions)]</sup>

    ```ruby
      # bad
      unless foo? && bar?
        ...
      end

      # okay
      if !(foo? && bar?)
        ...
      end
    ```

* <a name="parens-around-conditions"></a>Don't use parentheses around the
    condition of an `if/unless/while`.
    <sup>[[link](#parens-around-conditions)]</sup>

    ```ruby
    # bad
    if (x > 10)
      ...
    end

    # good
    if x > 10
      ...
    end

    ```

### Ternary operator

* <a name="avoid-complex-ternary"></a>Avoid the ternary operator (`?:`) except
    in cases where all expressions are extremely trivial. However, do use the
    ternary operator(`?:`) over `if/then/else/end` constructs for single line
    conditionals.<sup>[[link](#avoid-complex-ternary)]</sup>

    ```ruby
    # bad
    result = if some_condition then something else something_else end

    # good
    result = some_condition ? something : something_else
    ```

* <a name="no-nested-ternaries"></a>Use one expression per branch in a ternary
    operator. This also means that ternary operators must not be nested. Prefer
    `if/else` constructs in these cases.<sup>[[link](#no-nested-ternaries)]</sup>

    ```ruby
    # bad
    some_condition ? (nested_condition ? nested_something : nested_something_else) : something_else

    # good
    if some_condition
      nested_condition ? nested_something : nested_something_else
    else
      something_else
    end
    ```

* <a name="single-condition-ternary"></a>Avoid multiple conditions in ternaries. 
    Ternaries are best used with single conditions.
    <sup>[[link](#single-condition-ternary)]</sup>

* <a name="no-multiline-ternaries"></a>Avoid multi-line `?:` (the ternary
    operator), use `if/then/else/end` instead.
    <sup>[[link](#no-multiline-ternaries)]</sup>

    ```ruby
    # bad
    some_really_long_condition_that_might_make_you_want_to_split_lines ?
      something : something_else

    # good
    if some_really_long_condition_that_might_make_you_want_to_split_lines
      something
    else
      something_else
    end
    ```

## Syntax

* <a name="no-for"></a>Never use `for`, unless you know exactly why. Most of the 
    time iterators should be used instead. `for` is implemented in terms of
    `each` (so you're adding a level of indirection), but with a twist - `for`
    doesn't introduce a new scope (unlike `each`) and variables defined in its
    block will be visible outside it.<sup>[[link](#no-for)]</sup>

    ```ruby
    arr = [1, 2, 3]

    # bad
    for elem in arr do
      puts elem
    end

    # good
    arr.each { |elem| puts elem }
    ```

* <a name="single-line-blocks"></a>Prefer `{...}` over `do...end` for
    single-line blocks.  Avoid using `{...}` for multi-line blocks (multiline
    chaining is always ugly). Always use `do...end` for "control flow" and
    "method definitions" (e.g. in Rakefiles and certain DSLs).  Avoid `do...end`
    when chaining.<sup>[[link](#single-line-blocks)]</sup>

    ```ruby
    names = ["Bozhidar", "Steve", "Sarah"]

    # good
    names.each { |name| puts name }

    # bad
    names.each do |name| puts name end

    # good
    names.select { |name| name.start_with?("S") }.map { |name| name.upcase }

    # bad
    names.select do |name|
      name.start_with?("S")
    end.map { |name| name.upcase }
    ```

    Some will argue that multiline chaining would look okay with the use of
    `{...}`, but they should ask themselves if this code is really readable and
    whether the block's content can be extracted into nifty methods.

* <a name="redundant-return"></a>Avoid `return` where not required.
    <sup>[[link](#redundant-return)]</sup>

    ```ruby
    # bad
    def some_method(some_arr)
      return some_arr.size
    end

    # good
    def some_method(some_arr)
      some_arr.size
    end
    ```

* <a name="assignment-in-conditionals"></a>Don't use the return value of `=` in
    conditionals<sup>[[link](#assignment-in-conditionals)]</sup>

    ```ruby
    # bad - shows intended use of assignment
    if (v = array.grep(/foo/))
      ...
    end

    # bad
    if v = array.grep(/foo/)
      ...
    end

    # good
    v = array.grep(/foo/)
    if v
      ...
    end

    ```

* <a name="double-pipe-for-uninit"></a>Use `||=` freely to initialize variables.
    <sup>[[link](#double-pipe-for-uninit)]</sup>

    ```ruby
    # set name to Bozhidar, only if it's nil or false
    name ||= 'Bozhidar'
    ```

* <a name="no-double-pipes-for-bools"></a>Don't use `||=` to initialize boolean
    variables. (Consider what would happen if the current value happened to be
    `false`.)<sup>[[link](#no-double-pipes-for-bools)]</sup>

    ```ruby
    # bad - would set enabled to true even if it was false
    enabled ||= true

    # good
    enabled = true if enabled.nil?
    ```

* <a name="no-cryptic-perl"></a>Avoid using Perl-style special variables (like
    `$0-9`, `$`, etc. ). They are quite cryptic and their use in anything but
    one-liner scripts is discouraged. Prefer long form versions such as
    `$PROGRAM_NAME`.<sup>[[link](#no-cryptic-perl)]</sup>

* <a name="unused-block-args"></a>Use `_` for unused block arguments.
    <sup>[[link](#unused-block-args)]</sup>

    ```ruby
    # bad
    result = hash.map { |k, v| v + 1 }

    # good
    result = hash.map { |_, v| v + 1 }
    ```

* <a name="single-action-blocks"></a>When a method block takes only one
    argument, and the body consists solely of reading an attribute or calling
    one method with no arguments, use the `&:` shorthand.
    <sup>[[link](#single-action-blocks)]</sup>

    ```ruby
    # bad
    bluths.map { |bluth| bluth.occupation }
    bluths.select { |bluth| bluth.blue_self? }

    # good
    bluths.map(&:occupation)
    bluths.select(&:blue_self?)
    ```

* <a name="redundant-self"></a>Prefer `some_method` over `self.some_method` when 
    calling a method on the current instance.<sup>[[link](#redundant-self)]</sup>

    ```ruby
    # bad
    def end_date
      self.start_date + self.nights
    end

    # good
    def end_date
      start_date + nights
    end
    ```

    In the following three common cases, `self.` is required by the language
    and is good to use:

    1. When defining a class method: `def self.some_method`.
    2. The *left hand side* when calling an assignment method, including assigning
       an attribute when `self` is an ActiveRecord model: `self.guest = user`.
    3. Referencing the current instance's class: `self.class`.

## Naming

* <a name="snake-case"></a>Use `snake_case` for methods and variables.
    <sup>[[link](#snake-case)]</sup>

* <a name="camel-case"></a>Use `CamelCase` for classes and modules. (Keep
    acronyms like HTTP, RFC, XML uppercase.)
    <sup>[[link](#camel-case)]</sup>

* <a name="screaming-snake-case"></a>Use `SCREAMING_SNAKE_CASE` for other
    constants.<sup>[[link](#screaming-snake-case)]</sup>

* <a name="predicate-method-names"></a>The names of predicate methods (methods
    that return a boolean value) should end in a question mark.
    (i.e. `Array#empty?`).<sup>[[link](#predicate-method-names)]</sup>

* <a name="bang-methods"></a>The names of potentially "dangerous" methods
    (i.e. methods that modify `self` or the arguments, `exit!`, etc.) should
    end with an exclamation mark. Bang methods should only exist if a non-bang
    method exists. ([More on this][ruby-naming-bang].)
    <sup>[[link](#bang-methods)]</sup>

* <a name="throwaway-variables"></a>Name throwaway variables `_`.
    <sup>[[link](#throwaway-variables)]</sup>

    ```ruby
    payment, _ = Payment.complete_paypal_payment!(params[:token],
                                                  native_currency,
                                                  created_at)
    ```

## Classes

* <a name="avoid-class-variables"></a>Avoid the usage of class (`@@`) variables
    due to their "nasty" behavior in inheritance.
    <sup>[[link](#avoid-class-variables)]</sup>

    ```ruby
    class Parent
      @@class_var = 'parent'

      def self.print_class_var
        puts @@class_var
      end
    end

    class Child < Parent
      @@class_var = 'child'
    end

    Parent.print_class_var # => will print "child"
    ```

  As you can see all the classes in a class hierarchy actually share one
  class variable. Class instance variables should usually be preferred
  over class variables.

* <a name="singleton-methods"></a>Use `def self.method` to define singleton
    methods. This makes the methods more resistant to refactoring changes.
    <sup>[[link](#singleton-methods)]</sup>

    ```ruby
    class TestClass
      # bad
      def TestClass.some_method
        ...
      end

      # good
      def self.some_other_method
        ...
      end
    ```
* <a name="no-class-self"></a>Avoid `class << self` except when necessary,
    e.g. single accessors and aliased attributes.
    <sup>[[link](#no-class-self)]</sup>

    ```ruby
    class TestClass
      # bad
      class << self
        def first_method
          ...
        end

        def second_method_etc
          ...
        end
      end

      # good
      class << self
        attr_accessor :per_page
        alias_method :nwo, :find_by_name_with_owner
      end

      def self.first_method
        ...
      end

      def self.second_method_etc
        ...
      end
    end
    ```

* <a name="access-modifiers"></a>Indent the `public`, `protected`, and
    `private` methods as much the method definitions they apply to. Leave one
    blank line above and below them.<sup>[[link](#access-modifiers)]</sup>

    ```ruby
    class SomeClass
      def public_method
        # ...
      end

      private

      def private_method
        # ...
      end
    end
    ```

## Exceptions

* <a name="exception-flow-control"></a>Don't use exceptions for flow of control.
    <sup>[[link](#exception-flow-control)]</sup>

    ```ruby
    # bad
    begin
      n / d
    rescue ZeroDivisionError
      puts "Cannot divide by 0!"
    end

    # good
    if d.zero?
      puts "Cannot divide by 0!"
    else
      n / d
    end
    ```

* <a name="dont-rescue-exception"></a>Avoid rescuing the `Exception` class.
    <sup>[[link](#dont-rescue-exception)]</sup>

    ```ruby
    # bad
    begin
      # an exception occurs here
    rescue Exception
      # exception handling
    end

    # good
    begin
      # an exception occurs here
    rescue StandardError
      # exception handling
    end

    # acceptable
    begin
      # an exception occurs here
    rescue
      # exception handling
    end
    ```

## Collections

* <a name="set-unique"></a>Use `Set` instead of `Array` when dealing with unique
    elements. `Set` implements a collection of unordered values with no
    duplicates. This is a hybrid of `Array`'s intuitive inter-operation
    facilities and `Hash`'s fast lookup.<sup>[[link](#set-unique)]</sup>

* <a name="map-over-collect"></a>Prefer `map` over
    `collect`.<sup>[[link](#map-over-collect)]</sup>

* <a name="detect-over-find"></a>Prefer `detect` over `find`. The use of `find`
    is ambiguous with regard to ActiveRecord's `find` method - `detect` makes
    clear that you're working with a Ruby collection, not an AR object.
    <sup>[[link](#detect-over-find)]</sup>

* <a name="reduce-over-inject"></a>Prefer `reduce` over `inject`.
    <sup>[[link](#reduce-over-inject)]</sup>

* <a name="size-over-count"></a>Prefer `size` over either `length` or `count`
    for performance reasons.<sup>[[link](#size-over-count)]</sup>

* Use hashrocket syntax instead of JSON syntax for hashes. Hashrocket works no matter what type the key is, and symbol keys + symbol values look wonky in the JSON syntax.

    ```ruby
    # bad
    hash = { one: 1, two: 2, action: :update }

    # good
    hash = { :one => 1, :two => 2, :action => :update }
    ```

* Use symbols instead of strings as hash keys.

    ```ruby
    # bad
    hash = { 'one' => 1, 'two' => 2, 'three' => 3 }

    # good
    hash = { :one => 1, :two => 2, :three => 3 }
    ```

* <a name="multiline-hashes"></a>Use multi-line hashes when it makes the code
    more readable, and use trailing commas to ensure that parameter changes
    don't cause extraneous diff lines when the logic has not otherwise changed.
    <sup>[[link](#multiline-hashes)]</sup>

    ```ruby
    hash = {
      :protocol => 'https',
      :only_path => false,
      :controller => :users,
      :action => :set_password,
      :redirect => @redirect_url,
      :secret => @secret,
    }
    ```

* <a name="array-trailing-comma"></a>Use a trailing comma in an `Array` that
    spans more than 1 line<sup>[[link](#array-trailing-comma)]</sup>

    ```ruby
    # good
    array = [1, 2, 3]

    # good
    array = [
      "car",
      "bear",
      "plane",
      "zoo",
    ]
    ```

## Strings

* <a name="string-interpolation"></a>Prefer string interpolation instead of
    string concatenation:<sup>[[link](#string-interpolation)]</sup>

    ```ruby
    # bad
    email_with_name = user.name + ' <' + user.email + '>'

    # good
    email_with_name = "#{user.name} <#{user.email}>"
    ```

  Furthermore, keep in mind Ruby 1.9-style interpolation. Let's say you are
  composing cache keys like this:

    ```ruby
    CACHE_KEY = '_store'

    cache.write(@user.id + CACHE_KEY)
    ```

    Prefer string interpolation instead of string concatenation:

    ```ruby
    CACHE_KEY = '%d_store'

    cache.write(CACHE_KEY % @user.id)
    ```

* <a name="string-concatenation"></a>Avoid using `String#+` when you need to
    construct large data chunks. Instead, use `String#<<`. Concatenation mutates
    the string instance in-place  and is always faster than `String#+`, which
    creates a bunch of new string objects.<sup>[[link](#string-concatenation)]</sup>

    ```ruby
    # good and also fast
    html = ''
    html << '<h1>Page title</h1>'

    paragraphs.each do |paragraph|
      html << "<p>#{paragraph}</p>"
    end
    ```

## Regular Expressions

* <a name="regex-named-groups"></a>Avoid using `$1-9` as it can be hard to track
    what they contain. Named groups can be used instead.
    <sup>[[link](#regex-named-groups)]</sup>

    ```ruby
    # bad
    /(regexp)/ =~ string
    ...
    process $1

    # good
    /(?<meaningful_var>regexp)/ =~ string
    ...
    process meaningful_var
    ```

* <a name="caret-and-dollar-regexp"></a>Be careful with `^` and `$` as they
    match start/end of line, not string endings.  If you want to match the whole
    string use: `\A` and `\z`.<sup>[[link](#caret-and-dollar-regexp)]</sup>

    ```ruby
    string = "some injection\nusername"
    string[/^username$/]   # matches
    string[/\Ausername\z/] # don't match
    ```

* <a name="comment-regexes"></a>Use `x` modifier for complex regexps. This makes
    them more readable and you can add some useful comments. Just be careful as
    spaces are ignored.<sup>[[link](#comment-regexes)]</sup>

    ```ruby
    regexp = %r{
      start         # some text
      \s            # white space char
      (group)       # first group
      (?:alt1|alt2) # some alternation
      end
    }x
    ```

## Percent Literals

* <a name="percent-w"></a>Use `%w` freely.<sup>[[link](#percent-w)]</sup>

    ```ruby
    STATES = %w(draft open closed)
    ```

* <a name="percent-parens"></a>Use `%()` for single-line strings which require
    both interpolation and embedded double-quotes. For multi-line strings,
    prefer heredocs.<sup>[[link](#percent-parens)]</sup>

    ```ruby
    # bad - no interpolation needed
    %(<div class="text">Some text</div>)
    # should be '<div class="text">Some text</div>'

    # bad - no double-quotes
    %(This is #{quality} style)
    # should be "This is #{quality} style"

    # bad - multiple lines
    %(<div>\n<span class="big">#{exclamation}</span>\n</div>)
    # should be a heredoc.

    # good - requires interpolation, has quotes, single line
    %(<tr><td class="name">#{name}</td>)
    ```

* <a name="percent-r"></a>Use `%r` only for regular expressions matching *more
    than* one '/' character.<sup>[[link](#percent-r)]</sup>

    ```ruby
    # bad
    %r(\s+)

    # still bad
    %r(^/(.*)$)
    # should be /^\/(.*)$/

    # good
    %r(^/blog/2011/(.*)$)
    ```

## Rails

* <a name="next-line-return"></a>When immediately returning after calling
    `render` or `redirect_to`, put `return` on the next line, not the same line.
    <sup>[[link](#next-line-return)]</sup>

    ```ruby
    # bad
    render :text => 'Howdy' and return

    # good
    render :text => 'Howdy'
    return

    # still bad
    render :text => 'Howdy' and return if foo.present?

    # good
    if foo.present?
      render :text => 'Howdy'
      return
    end
    ```

### Scopes
* <a name="scope-lambda"></a>When defining ActiveRecord model scopes, wrap the
    relation in a `lambda`.  A naked relation forces a database connection to be
    established at class load time (instance startup).
    <sup>[[link](#scope-lambda)]</sup>

    ```ruby
    # bad
    scope :foo, where(:bar => 1)

    # good
    scope :foo, -> { where(:bar => 1) }
    ```

## Be Consistent

> If you're editing code, take a few minutes to look at the code around you and
> determine its style. If they use spaces around all their arithmetic
> operators, you should too. If their comments have little boxes of hash marks
> around them, make your comments have little boxes of hash marks around them
> too.

> The point of having style guidelines is to have a common vocabulary of coding
> so people can concentrate on what you're saying rather than on how you're
> saying it. We present global style rules here so people know the vocabulary,
> but local style is also important. If code you add to a file looks
> drastically different from the existing code around it, it throws readers out
> of their rhythm when they go to read it. Avoid this.

&mdash;[Google C++ Style Guide][google-c++]

[crowdtap-javascript]: https://github.com/crowdtap/javascript
[bbatsov-ruby]: https://github.com/bbatsov/ruby-style-guide
[github-ruby]: https://github.com/styleguide/ruby
[google-c++]: http://google-styleguide.googlecode.com/svn/trunk/cppguide.xml
[google-c++-comments]: http://google-styleguide.googlecode.com/svn/trunk/cppguide.xml#Comments
[google-python-comments]: http://google-styleguide.googlecode.com/svn/trunk/pyguide.html#Comments
[ruby-naming-bang]: http://dablog.rubypal.com/2007/8/15/bang-methods-or-danger-will-rubyist
