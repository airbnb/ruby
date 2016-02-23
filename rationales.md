# Rationales

This document contains what are at times lengthy rationales and justifications
for the decisions made in the main [Style guide](./README.md).

## Table of Contents
  1. [Whitespace](#whitespace)
    1. [Indentation](#indentation)
  1. [Line Length](#line-length)

## Whitespace

### Indentation

<a name="indent-when-as-case"></a>
Indent `when` as deep as `case`.
```ruby
# bad
kind = case year
       when 1850..1889 then 'Blues'
       when 1890..1909 then 'Ragtime'
       when 1910..1929 then 'New Orleans Jazz'
       when 1930..1939 then 'Swing'
       when 1940..1950 then 'Bebop'
       else 'Jazz'
       end

# good
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
```

<a name="align-function-params"></a>
Align function parameters either all on the same line or one per line.
```ruby
# bad
def self.create_translation(phrase_id, phrase_key, target_locale,
                            value, user_id, do_xss_check, allow_verification)
  ...
end

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
```

<a name="indent-multi-line-bool"></a>
Indent succeeding lines in multi-line boolean expressions.
```ruby
# bad
def is_eligible?(user)
  Trebuchet.current.launch?(ProgramEligibilityHelper::PROGRAM_TREBUCHET_FLAG) &&
  is_in_program?(user) &&
  program_not_expired
end

# good
def is_eligible?(user)
  Trebuchet.current.launch?(ProgramEligibilityHelper::PROGRAM_TREBUCHET_FLAG) &&
    is_in_program?(user) &&
    program_not_expired
end
```

### Line Length

Keeping code visually grouped together (as a 100-character line limit enforces)
makes it easier to understand. For example, you don't have to scroll back and
forth on one line to see what's going on -- you can view it all together.

Here are examples from our codebase showing several techniques for
breaking complex statements into multiple lines that are all < 100
characters. Notice techniques like:

* liberal use of linebreaks inside unclosed `(` `{` `[`
* chaining methods, ending unfinished chains with a `.`
* composing long strings by putting strings next to each other, separated
  by a backslash-then-newline.
* breaking long logical statements with linebreaks after operators like
  `&&` and `||`

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
                    :beveled_big_icon => "stamp") do %>
    <%= I18n.t("email.reservation_confirmed_guest.visa.russia.details_copy",
               :default => "Foreign guests travelling to Russia may need to obtain a visa...") %>
  <% end %>
<% end %>
```

These code snippets are very much more readable than the alternative:

```ruby
scope = Translation::Phrase.includes(:phrase_translations).joins(:phrase_screenshots).where(:phrase_screenshots => { :controller => controller_name, :action => JAROMIR_JAGR_SALUTE })

translation = FactoryGirl.create(:phrase_translation, :locale => :is, :phrase => phrase, :key => 'phone_number_not_revealed_time_zone', :value => 'Símanúmerið þitt verður ekki birt. Það er aðeins hægt að hringja á milli 9:00 og 21:00 %{time_zone}.')

if @reservation_alteration.checkin == @reservation.start_date && @reservation_alteration.checkout == (@reservation.start_date + @reservation.nights)
  redirect_to_alteration @reservation_alteration
end
```

```erb
<% if @presenter.guest_visa_russia? %>
  <%= icon_tile_for(I18n.t("email.reservation_confirmed_guest.visa.details_header", :default => "Visa for foreign Travelers"), :beveled_big_icon => "stamp") do %>
    <%= I18n.t("email.reservation_confirmed_guest.visa.russia.details_copy", :default => "Foreign guests travelling to Russia may need to obtain a visa prior to...") %>
  <% end %>
<% end %>
```
