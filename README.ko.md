# 루비 스타일 가이드

이 문서는 에어비앤비의 루비 스타일 가이드의 한국어판 입니다.

[Github's guide][github-ruby] 와 [Bozhidar Batsov's guide][bbatsov-ruby]의 영향을 받았습니다.

에어비앤비는 [JavaScript Style Guide][airbnb-javascript]도 만들고 있습니다.


## 목차
  1.  [Whitespace](#whitespace)
      1. [Indentation](#indentation)
      1. [Inline](#inline)
      1. [Newlines](#newlines)
  1.  [Line Length](#line-length)
  1.  [Commenting](#commenting)
      1. [File/class-level comments](#fileclass-level-comments)
      1. [Function comments](#function-comments)
      1. [Block and inline comments](#block-and-inline-comments)
      1. [Punctuation, spelling, and grammar](#punctuation-spelling-and-grammar)
      1. [TODO comments](#todo-comments)
      1. [Commented-out code](#commented-out-code)
  1.  [Methods](#methods)
      1. [Method definitions](#method-definitions)
      1. [Method calls](#method-calls)
  1.  [Conditional Expressions](#conditional-expressions)
      1. [Conditional keywords](#conditional-keywords)
      1. [Ternary operator](#ternary-operator)
  1.  [Syntax](#syntax)
  1.  [Naming](#naming)
  1.  [Classes](#classes)
  1.  [Exceptions](#exceptions)
  1.  [Collections](#collections)
  1. [Strings](#strings)
  1. [Regular Expressions](#regular-expressions)
  1. [Percent Literals](#percent-literals)
  1. [Rails Specific](#rails)
  1. [Be Consistent](#be-consistent)

## Whitespace

### Indentation

* 2칸 들여쓰기로 소프트탭을 사용합니다.

* when 은 case 만큼 들여쓰기 합니다.

    ```Ruby
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

* 함수의 파라미터는 같은 라인에 다 쓰거나 한라인에 하나씩 씁니다.

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

    # bad
    def self.create_translation(phrase_id, phrase_key, target_locale,
                                value, user_id, do_xss_check, allow_verification)
      ...
    end
    ```

* 여러줄의 참거짓 표현식에서는 들여쓰기합니다.

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

* 문장끝에 공백을 절대 두지 않습니다.

* 연산자 양옆에 빈칸을 두고 그후에 콤마, 콜론, 세미콜론을 씁니다.

  `{` and before `}`.

    ```Ruby
    sum = 1 + 2
    a, b = 1, 2
    1 > 2 ? true : false; puts 'Hi'
    [1, 2, 3].each { |e| puts e }
    ```

* `(`, `[` or before `]`, `)` 뒤에 절대 빈칸을 두지 않습니다.

    ```Ruby
    some(arg).other
    [1, 2, 3].length
    ```

### Newlines

* `if` 조건문뒤에 여러줄로 다른 조건이 문장에 오는 경우 새로운 줄에 씁니다.

  ```ruby
  if @reservation_alteration.checkin == @reservation.start_date &&
     @reservation_alteration.checkout == (@reservation.start_date + @reservation.nights)

    redirect_to_alteration @reservation_alteration
  end
  ```

* 조건문, case 문, 그외 블럭후에는 새로운 줄을 추가합니다.

  ```ruby
  if robot.is_awesome?
    send_robot_present
  end

  robot.add_trait(:human_like_intelligence)
  ```

## Line Length

읽을 수 있는 길이로 코드의 라인을 유지합니다. 최소한 어떤 이유가 있지 않는 한 100자 미만으로
유지합니다. 시각적으로 한눈에 볼수 있도록 코드를 그룹화하여 유지(100자 라인제한 적용처럼)하여야
이해하기 쉽우므로 당신은 다시 스크롤하지 않고 코드에 무슨 일이 일어나고 있는지
한눈에 볼 수 있습니다

여기에 우리의 코드베이스에 있는 몇 가지 예의 기술을 보여주겠습니다.
모든 라인을 100자안에 여러 라인으로 복잡한 문장을 분리하는 방법입니다.
다음과 같이:

* `(` `{` `[` 닫기전에 줄넘김은 자유롭게 사용합니다.
* 메써드를 연결할때 끝나기전에 `.` 으로 연결합니다.
* 긴 문자열을 쓸때는 백슬러쉬 `\` 로 새로운 라인으로 넘기고 각각 문자열을 씁니다.
* 긴 논리 조건문을 나눌때는 `&&` 와 `||` 같은 연산자뒤에 줄넘김을 합니다.

```ruby
scope = Translation::Phrase.includes(:phrase_translations).
  joins(:phrase_screenshots).
  where(:phrase_screenshots => {
    :controller => controller_name,
    :action => JAROMIR_JAGR_SALUTE,
  })
```

```ruby
translation = FactoryGirl.create(
  :phrase_translation,
  :locale => :is,
  :phrase => phrase,
  :key => 'phone_number_not_revealed_time_zone',
  :value => 'Símanúmerið þitt verður ekki birt. Það er aðeins hægt að hringja á '\
            'milli 9:00 og 21:00 %{time_zone}.'
)
```

```ruby
if @reservation_alteration.checkin == @reservation.start_date &&
   @reservation_alteration.checkout == (@reservation.start_date + @reservation.nights)

  redirect_to_alteration @reservation_alteration
end
```

```erb
<% if @presenter.guest_visa_russia? %>
  <%= icon_tile_for(I18n.t("email.reservation_confirmed_guest.visa.details_header",
                           :default => "Visa for foreign Travelers"),
                    :beveled_big_icon => "stamp" do %>
    <%= I18n.t("email.reservation_confirmed_guest.visa.russia.details_copy",
               :default => "Foreign guests travelling to Russia may need to obtain a visa...") %>
  <% end %>
<% end %>
```

위 코드가 아래의 다른 방식보다 훨씬 더 읽기 쉬운 코드입니다.

```ruby
scope = Translation::Phrase.includes(:phrase_translations).joins(:phrase_screenshots).where(:phrase_screenshots => { :controller => controller_name, :action => JAROMIR_JAGR_SALUTE })

translation = FactoryGirl.create(:phrase_translation, :locale => :is, :phrase => phrase, :key => 'phone_number_not_revealed_time_zone', :value => 'Símanúmerið þitt verður ekki birt. Það er aðeins hægt að hringja á milli 9:00 og 21:00 %{time_zone}.')

if @reservation_alteration.checkin == @reservation.start_date && @reservation_alteration.checkout == (@reservation.start_date + @reservation.nights)
  redirect_to_alteration @reservation_alteration
end
```

```erb
<% if @presenter.guest_visa_russia? %>
  <%= icon_tile_for(I18n.t("email.reservation_confirmed_guest.visa.details_header", :default => "Visa for foreign Travelers"), :beveled_big_icon => "stamp" do %>
    <%= I18n.t("email.reservation_confirmed_guest.visa.russia.details_copy", :default => "Foreign guests travelling to Russia may need to obtain a visa prior to...") %>
  <% end %>
<% end %>
```

## Commenting

> 작성하는 것이 쉽지 않지만, 주석은 코드의 가독성을 유지하는 데 절대적으로 중요한 역할을 한다.
> 다음 규칙은 어디에 무엇을 주석으로 달아야 할 지를 설명한다. 하지만 기억할 점은 주석은 매우 중요하지만,
> 가장 좋은 코드는 스스로에 대해 설명을 할 수 있는 코드라는 것이다.
> 타입과 변수에 이해할 수 있는 이름을 짓는 것이 이상한 이름을 짓고 주석으로 설명하는 것보다 훨씬 좋다.

> 주석을 작성할 때에는 주석을 읽는 이를 위해서, 즉 그 코드를 보고 이해해야 하는 다음 작업자를 위해 작성하라.
> 관대함을 가지라 - 다음 작업자는 본인일 수도 있다!

&mdash;[Google C++ Style Guide][google-c++] [번역](http://jongwook.github.io/google-styleguide/trunk/cppguide.xml#%EC%A3%BC%EC%84%9D)

이 섹션 부분은 구글의 [C++][google-c++-comments] 와 [Python][google-python-comments] 스타일 가이드들에서 많이 빌려왔습니다.

### File/class-level comments

모든 클래스는 그것이 어떻게 쓰여지는지에 대해서 주석으로 정의되어야 합니다.
하나의 파일은 빈 클래스를 포함할수도 있고 하나 이상의 클래스를 포함할수 있기에 가장 위에 주석을 포함합니다.

```ruby
# Automatic conversion of one locale to another where it is possible, like
# American to British English.
module Translation
  # Class for converting between text between similar locales.
  # Right now only conversion between American English -> British, Canadian,
  # Australian, New Zealand variations is provided.
  class PrimAndProper
    def initialize
      @converters = { :en => { :"en-AU" => AmericanToAustralian.new,
                               :"en-CA" => AmericanToCanadian.new,
                               :"en-GB" => AmericanToBritish.new,
                               :"en-NZ" => AmericanToKiwi.new,
                             } }
    end

  ...

  # Applies transforms to American English that are common to
  # variants of all other English colonies.
  class AmericanToColonial
    ...
  end

  # Converts American to British English.
  # In addition to general Colonial English variations, changes "apartment"
  # to "flat".
  class AmericanToBritish < AmericanToColonial
    ...
  end
```

### Function comments

모든 함수는 입력과 출력이 다음과 같은 기준으로 언급되어야 합니다.
예를 들자면 "파일을 열기" 와 같은 설명 내용은 기능을 설명하지 않습니다.
그것보다는 반복적으로 함수가 무엇을 하는지 주석이 함수의 코드를 설명해야 합니다.

* 외부에서 볼수 없게
* 아주 짧게
* 명백하게

당신은 당신이 원하는 어떤 형식으로든 주석을 쓸 수 있습니다. 하지만 루비에서는 두가지의 인기있는
문서 방식은 [TomDoc] (http://tomdoc.org/) 와
[YARD] (http://rubydoc.info/docs/yard/file/docs/GettingStarted.md) 입니다.
물론 그냥 간단하게 쓸 수도 있습니다:

```ruby
# Returns the fallback locales for the_locale.
# If opts[:exclude_default] is set, the default locale, which is otherwise
# always the last one in the returned list, will be excluded.
#
# For example:
#   fallbacks_for(:"pt-BR")
#     => [:"pt-BR", :pt, :en]
#   fallbacks_for(:"pt-BR", :exclude_default => true)
#     => [:"pt-BR", :pt]
def fallbacks_for(the_locale, opts = {})
  ...
end
```

### Block and inline comments

주석을 달 수 있는 마지막 부분은 코드의 애매한 부분입니다.
만약 당신이 다음 코드 리뷰에서 설명할것이 있다면 바로 그것에 대해 주석을 적고,
복잡한 작업이라면 그 전에 코멘트 몇 줄을 적고 시작합니다.
명확하지 않다면 줄의 끝에 의견을 적습니다.


```ruby
def fallbacks_for(the_locale, opts = {})
  # dup() to produce an array that we can mutate.
  ret = @fallbacks[the_locale].dup

  # We make two assumptions here:
  # 1) There is only one default locale (that is, it has no less-specific
  #    children).
  # 1) The default locale is just a language. (Like :en, and not :"en-US".)
  if opts[:exclude_default] &&
      ret.last == self.default_locale &&
      ret.last != language_from_locale(the_locale)
    ret.pop
  end

  ret
end
```

다시 말하자면, 절대 코드를 설명하지 않습니다.
코드를 읽는 사람은 당신보다 더 나은 (당신이 해야 할 것을 의미하지 않지만) 것을 알고 있습니다.

### Punctuation, spelling and grammar

콤마찍기, 철자, 문법은 안좋은 경우보다 잘 읽을수 있게 합니다.
(영어일때 필요한 내용같아서 나머지 번역 생략)

### TODO comments

TODO 주석은 임시적으로 짧은 시간내에 해결해야 하거나 해결했지만 완벽하지 않은 경우에 쓰여집니다.
TODO 형식은 괄호안에 담당자 이름을 넣어야하며 그래야 나중에 검색하여 보다 자세히 알고 수정을 요청할수 있습니다.
예를 들자면 당신이 TODO를 만든다면 항상 당신이름이 들어갈 것입니다.

```ruby
  # bad
  # TODO(RS): Use proper namespacing for this constant.

  # bad
  # TODO(drumm3rz4lyfe): Use proper namespacing for this constant.

  # good
  # TODO(Ringo Starr): Use proper namespacing for this constant.
```

### Commented-out code

절대 주석처리된 코드를 우리의 코드베이스에 남겨두지마라.

## Methods

### Method definitions

* `def` 괄호는 매개변수가 없는 경우에만 생략할수 있다.

     ```Ruby
     def some_method
       # body omitted
     end

     def some_method_with_parameters(arg1, arg2)
       # body omitted
     end
     ```

* 기본 값은 사용하지 않는다. 대신에 옵션으로 해쉬는 사용합니다.

    ```Ruby
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


* 만약 메써드가 값을 반환하는 경우는 메써드 호출을 위해 **괄호** 를 사용합니다.

    ```ruby
    # bad
    @current_user = User.find_by_id 1964192

    # good
    @current_user = User.find_by_id(1964192)
    ```

* 만약 첫번째 인자가 괄호를 사용한 경우

    ```ruby
    # bad
    put! (x + y) % len, value

    # good
    put!((x + y) % len, value)
    ```

* 절대 빈칸 사이에 메써드 이름을 넣고 괄호를 열지않습니다.

    ```Ruby
    # bad
    f (3 + 2) + 1

    # good
    f(3 + 2) + 1
    ```

* 만약 메써드 호출이 아무 인자도 받지 않는다면 **괄호** 를 생략합니다.

    ```ruby
    # bad
    nil?()

    # good
    nil?
    ```

* 만약 메써드가 값을 반환하지 않는다면(아니면 신경쓰지 않는다면), 괄호는 선택입니다. (특히, 인자값들이 여러줄에 넘친다면 괄호는 읽기 좋게 만들것입니다.)

    ```ruby
    # okay
    render(:partial => 'foo')

    # okay
    render :partial => 'foo'
    ```

다른 경우:

* 만약 메써드가 마지막 인자로 해쉬 인자를 받아들인다면, `{` `}` 를 쓰지 않습니다.

    ```ruby
    # bad
    get '/v1/reservations', { :id => 54875 }

    # good
    get '/v1/reservations', :id => 54875
    ```

## Conditional Expressions

### Conditional keywords

* 절대 `if/unless` 을 여러라인에 걸쳐서 `then` 을 쓰지않습니다.

    ```Ruby
    # bad
    if some_condition then
      ...
    end

    # good
    if some_condition
      ...
    end
    ```

* `and`, `or`, 그리고 `not` 키워드는 금지되었습니다. 항상 `&&`, `||`, 그리고 `!` 를 대신씁니다.

* `if/unless` 문은 문장을 간단하게 만드는데 좋습니다. 하지만 간단하게 만들기 위해서는 한줄에 하나만 써야합니다.

    ```Ruby
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
    return if self.reconciled?
    ```

* 절대 `unless` 를 `else` 와 쓰지 않습니다. 이런 경우는 `if` 문으로 참일 경우를 먼저 씁니다.

    ```Ruby
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

* `unless` 는 여러라인에 걸쳐 쓰지 않습니다.

    ```Ruby
      # bad
      unless foo? && bar?
        ...
      end

      # okay
      if !(foo? && bar?)
        ...
      end
    ```

* `if/unless/while` 에 괄호는 쓰지 않습니다.
   최소한 값을 넣는 조건에서만 씁니다. (`=` 로 값을 리턴하는 경우)

    ```Ruby
    # bad
    if (x > 10)
      ...
    end

    # good
    if x > 10
      ...
    end

    # ok
    if (x = self.next_value)
      ...
    end
    ```

### Ternary operator

* 삼자연산자 (`?:`)는 모든 표현식에 사용하지 않는다. 그러나, 한줄에 `if/then/else/end` 를 만들때는 써도 된다.

    ```Ruby
    # bad
    result = if some_condition then something else something_else end

    # good
    result = some_condition ? something : something_else
    ```

* 삼자연산자는 한개의 분기조건에 하나만 씁니다. 이 의미는 안쪽에 다시 쓰지 않는다는 것으로 `if/else` 문으로 만드는것을 추천합니다.

    ```Ruby
    # bad
    some_condition ? (nested_condition ? nested_something : nested_something_else) : something_else

    # good
    if some_condition
      nested_condition ? nested_something : nested_something_else
    else
      something_else
    end
    ```

* `?:` 여러줄에 사용하지 말고 대신에 `if/then/else/end` 를 사용하라.

## Syntax

* 절대 당신이 최소한 정확히 알기전엔 `for` 문은 사용하지마라.
  대부분의 반복자로 대신 쓸수 있다. `for` 는 `each` 의 다른 레벨의 구현이다.
  그러나 `for` 는 새로운 범위로 만들고 변수를 블럭 범위에서 새로 만들어 져진다.

    ```Ruby
    arr = [1, 2, 3]

    # bad
    for elem in arr do
      puts elem
    end

    # good
    arr.each { |elem| puts elem }
    ```


* 한줄 블럭에서는 `do...end` 보다는 `{...}` 를 쓰는게 낫습니다.
  여러줄에서는 `{...}` 는 쓰지 않고 `do...end` 로 흐름 제어와 메써드 정의를 합니다.

    ```Ruby
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

    어떤 경우는 여러줄에 `{...}` 블럭도 보기 괜찬을 수 있지만 정말 읽기 좋고 괜찬은지 물어봐야 합니다.

* 불필요한 `return` 은 쓰지 않습니다.

    ```Ruby
    # bad
    def some_method(some_arr)
      return some_arr.size
    end

    # good
    def some_method(some_arr)
      some_arr.size
    end
    ```

* `=` 값을 대입하고 리턴하여 사용은 괜찬지만, 괄호로 둘러싸야 합니다.

    ```Ruby
    # good - shows intended use of assignment
    if (v = array.grep(/foo/))
      ...
    end

    # bad
    if v = array.grep(/foo/)
      ...
    end

    # also good - shows intended use of assignment and has correct precedence
    if (v = self.next_value) == "hello"
      ...
    end
    ```

* `||=` 는 초기화값에 자유롭게 사용합니다.

    ```Ruby
    # set name to Bozhidar, only if it's nil or false
    name ||= 'Bozhidar'
    ```

* 하지만 `||=` 를 참거짓을 대입하는데 사용하면 안됩니다.
  `false` 값일때  어떤일이 벌어질지 주의해야 합니다.

    ```Ruby
    # bad - would set enabled to true even if it was false
    enabled ||= true

    # good
    enabled = true if enabled.nil?
    ```

* `$0-9`, `$`등 펄스타일 특수문자는 사용하지 않습니다.
   그것들은 아주 보기 어려우며 한줄에 넣는 스크립트엔 권장하지 않으며
   `$PROGRAM_NAME` 과 같은 긴 버전이름은 괜찬습니다.

* `_` 은 사용하지 않는 블럭 인자에 사용합니다.

    ```Ruby
    # bad
    result = hash.map { |k, v| v + 1 }

    # good
    result = hash.map { |_, v| v + 1 }
    ```

* 메써드 블럭이 단 하나의 인자만을 쓸때 `&:` 로 짧게 만듭니다.

    ```ruby
    # bad
    bluths.map { |bluth| bluth.occupation }
    bluths.select { |bluth| bluth.blue_self? }

    # good
    bluths.map(&:occupation)
    bluths.select(&:blue_self?)
    ```

## Naming

* `snake_case` 로 메써드와 변수를 정합니다.

* `CamelCase` 는 클래스와 모듈로 정합니다. (HTTP, RFC, XML같은 약자는 그대로 씁니다.)

* `SCREAMING_SNAKE_CASE` 는 상수에 씁니다.

* 참거짓 값을 반환하는 메써드는 물음표를 끝에 붙여야 한다.(예, `Array#empty?`)

* 잠재적으로 "위험한" 메써드 이름은 `!`로 끝나야 합니다.

* 날려버리는 변수 이름은 `_` 를 씁니다.

    ```Ruby
    payment, _ = Payment.complete_paypal_payment!(params[:token],
                                                  native_currency,
                                                  created_at)
    ```

## Classes

* 클래스 `@@` 쓰는 변수는 안좋은 영향때문에 쓰지 말아야 합니다.

    ```Ruby
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

    당신이 알고 있듯이 모든 클래스는 하나의 클래스를 상속받으면 변수도 공유합니다.
    클래스 상속 변수는 보통 클래스의 변수를 덥어버립니다.

* `def self.method` 는 싱글톤 메써드를 정의 합니다.

    ```Ruby
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

* `class << self` 는 필요할때외엔 쓰지 않습니다.

    ```Ruby
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

* `public`, `protected`, `private` 메써드는 선언할때 들여쓰고 사이에 한줄을 띠웁니다.

    ```Ruby
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

* 흐름 제어에 예외처리를 쓰지 않습니다.

    ```Ruby
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

* `Exception` 클래스는 예외에 쓰지 않습니다.

    ```Ruby
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

* `Array` 대신에 `Set` 를 유일한 값을 가질때 써야 합니다.
  `Set` 는 중복되지 않고 정렬하지 않은 구현이며 `Array` 의 직관적이고 삽입가능하고
  `Hash` 로 빠르게 찾기가 가능합니다.

* 해쉬키대신에 심볼을 사용합니다.

    ```Ruby
    # bad
    hash = { 'one' => 1, 'two' => 2, 'three' => 3 }

    # good
    hash = { :one => 1, :two => 2, :three => 3 }
    ```

* 여러줄에 해쉬를 쓸때는 끝에 콤마를 쓰고 넘기면 차이점이 발생할때 보다 쉽게 알아볼수 있습니다.

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

## Strings

* 문자열 합치기보다 문자열 삽입을 씁니다.

    ```Ruby
    # bad
    email_with_name = user.name + ' <' + user.email + '>'

    # good
    email_with_name = "#{user.name} <#{user.email}>"
    ```

    또한, 루비 1.9 스타일의 삽입법에 유의하십시오.
    당신이 이 같은 캐시 키를 구성한다고 가정 해 봅시다:

    ```ruby
    CACHE_KEY = '_store'

    cache.write(@user.id + CACHE_KEY)
    ```

    Prefer string interpolation instead of string concatentation:

    ```ruby
    CACHE_KEY = '%d_store'

    cache.write(CACHE_KEY % @user.id)
    ```

* 많은 데이터 덩어리를 만들때 필요하여 `String#+` 로 연결하는거 대신에 `String#<<` 를 사용합니다.
  `String#<<` 사용한 문자열 연결은 그 자리에서 인스턴스를 반환하기 때문에 항상 `String#+` 보다 빠릅니다.

    ```Ruby
    # good and also fast
    html = ''
    html << '<h1>Page title</h1>'

    paragraphs.each do |paragraph|
      html << "<p>#{paragraph}</p>"
    end
    ```

## Regular Expressions

* `$1-9` 는 무엇을 포함하게 되는지 추적하기 어렵기 때문에 사용하지 말고 이름 그룹을 대신 사용하라.

    ```Ruby
    # bad
    /(regexp)/ =~ string
    ...
    process $1

    # good
    /(?<meaningful_var>regexp)/ =~ string
    ...
    process meaningful_var
    ```

* `^` 와 `$` 는 문자열 끌이 아니라 시작/끝 라인에 매치되기때문에 주의해야 합니다.
 만약 당신이 문자열을 매치하고자 합니다면 `\A` 와 `\z` 를 사용해야 합니다.

    ```Ruby
    string = "some injection\nusername"
    string[/^username$/]   # matches
    string[/\Ausername\z/] # don't match
    ```

* `x` 는 복잡한 정규표현식에 사용합니다. 이것은 보다 읽기 쉽게 하고 좀 더 유용한 주석을 추가할 수 있게 합니다.
 단지 빈칸은 무시한다는 것을 주의해야 합니다.

    ```Ruby
    regexp = %r{
      start         # some text
      \s            # white space char
      (group)       # first group
      (?:alt1|alt2) # some alternation
      end
    }x
    ```

## Percent Literals

* `%w` 는 자유롭게 사용합니다.

    ```Ruby
    STATES = %w(draft open closed)
    ```

* `%()` 는 쌍따옴표와 삽입하는 양쪽에 필요한 한줄의 문자열에 사용합니다.
  여러줄일 경우는 heredocs 가 좋습니다.

    ```Ruby
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

* `%r` 은 오직 정규표현식에서 하나 이상의 '/' 문자를 맞출때 사용합니다.

    ```Ruby
    # bad
    %r(\s+)

    # still bad
    %r(^/(.*)$)
    # should be /^\/(.*)$/

    # good
    %r(^/blog/2011/(.*)$)
    ```

## Rails

* `render` 이나 `redirect_to` 를 호출한후에 즉각 리턴하는 경우는 같은 라인이 아니라 다음 라인에 씁니다.

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

## Be Consistent

> 코드를 수정하는 경우 몇 분 정도 주변의 코드를 살펴보고 그것의 스타일을 판단하라.
> 그 코드가 if문 주변에 스페이스를 사용한다면 그것에 따라야 한다.
> 만약 그 코드의 주석들이 작은 박스와 별표들을 사용한다면 새로 작성하는 코드도 작은 박스와 별표를 사용해야 한다.

> 스타일 가이드라인의 요점은 코딩에 있어서 공통적인 어휘를 가짐으로써 사람들이 서로의 말하는 방식보다
> 내용에 집중할 수 있게 하기 위함이고, 여기에 전체적인 스타일 규칙을 소개하는 것은 사람들이
> 그 어휘를 알게 하기 위함이다. 하지만 부분적인 스타일 규칙도 중요하다.
> 어떤 파일에 다른 부분과 심하게 달라 보이는 코드를 추가하는 경우 그 불연속성은 다른 사람들이
> 그 코드를 읽는 리듬을 벗어나게 할 것이다. 그렇게 하지 말자.

&mdash;[Google C++ Style Guide][google-c++] [번역](http://jongwook.github.io/google-styleguide/trunk/cppguide.xml)

[airbnb-javascript]: https://github.com/airbnb/javascript
[bbatsov-ruby]: https://github.com/bbatsov/ruby-style-guide
[github-ruby]: https://github.com/styleguide/ruby
[google-c++]: http://google-styleguide.googlecode.com/svn/trunk/cppguide.xml
[google-c++-comments]: http://google-styleguide.googlecode.com/svn/trunk/cppguide.xml#Comments
[google-python-comments]: http://google-styleguide.googlecode.com/svn/trunk/pyguide.html#Comments
[ruby-naming-bang]: http://dablog.rubypal.com/2007/8/15/bang-methods-or-danger-will-rubyist
