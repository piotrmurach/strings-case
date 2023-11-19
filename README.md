<div align="center">
  <img width="225" src="https://github.com/piotrmurach/strings/blob/master/assets/strings_logo.png" alt="strings logo" />
</div>

# Strings::Case

[![Gem Version](https://badge.fury.io/rb/strings-case.svg)][gem]
[![Actions CI](https://github.com/piotrmurach/strings-case/actions/workflows/ci.yml/badge.svg)][gh_actions_ci]
[![Build status](https://ci.appveyor.com/api/projects/status/yr87c96wxp1cw2ep?svg=true)][appveyor]
[![Maintainability](https://api.codeclimate.com/v1/badges/7938258c4af196a19843/maintainability)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/github/piotrmurach/strings-case/badge.svg?branch=master)][coverage]

[gem]: http://badge.fury.io/rb/strings-case
[gh_actions_ci]: https://github.com/piotrmurach/strings-case/actions/workflows/ci.yml
[appveyor]: https://ci.appveyor.com/project/piotrmurach/strings-case
[codeclimate]: https://codeclimate.com/github/piotrmurach/strings-case/maintainability
[coverage]: https://coveralls.io/github/piotrmurach/strings-case?branch=master

> Convert strings to different cases.

**Strings::Case** provides string case conversions for
[Strings](https://github.com/piotrmurach/strings) utilities.

## Features

* No monkey-patching String class
* Convert strings to many common cases
* Support for Unicode characters
* Preserve acronyms

## Installation

Add this line to your application's Gemfile:

```ruby
gem "strings-case"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install strings-case

## Contents

* [1. Usage](#1-usage)
* [2. API](#2-api)
  * [2.1 configure](#21-configure)
  * [2.2 camelcase](#22-camelcase)
  * [2.3 constcase](#23-constcase)
  * [2.4 headercase](#24-headercase)
  * [2.5 kebabcase | dashcase](#25-kebabcase--dashcase)
  * [2.6 pascalcase](#26-pascalcase)
  * [2.7 pathcase](#27-pathcase)
  * [2.8 sentencecase](#28-sentencecase)
  * [2.9 snakecase | underscore](#29-snakecase--underscore)
  * [2.10 titlecase](#210-titlecase)
* [3. Extending String class](#3-extending-string-class)

## 1. Usage

Start by creating an instance of the `Strings::Case` class:

```ruby
strings = Strings::Case.new
```

Then, use one of many case conversion methods, for example,
the `snakecase` method:

```ruby
strings.snakecase("FooBarBaz")
# => "foo_bar_baz"
```

As a convenience, case conversion methods are also available on class:

```ruby
Strings::Case.snakecase("FooBarBaz")
# => "foo_bar_baz"
```

Case conversion methods will transform any string into an expected case:

```ruby
strings.snakecase("supports IPv6 on iOS?")
# => "supports_i_pv6_on_i_os"
```

The methods also support converting Unicode characters:

```ruby
strings.snakecase("ЗдравствуйтеПривет")
# => "здравствуйте_привет"
```

To preserve acronyms for all case conversions, configure them once
on an instance:

```ruby
strings.configure do |config|
  config.acronym "IPv6"
  config.acronym "iOS"
end
```

This will preserve acronyms for any case conversion method:

```ruby
strings.snakecase("supports IPv6 on iOS?")
# => "supports_ipv6_on_ios"
```

Or, use the `acronyms` keyword in a case conversion method:

```ruby
strings.snakecase("supports IPv6 on iOS?", acronyms: %w[IPv6 iOS])
# => "supports_ipv6_on_ios"
```

Here is a quick summary of available case conversions:

| Case Type                     | Result          |
| ----------------------------- | --------------- |
| `camelcase("foo bar baz")`    | `"fooBarBaz"`   |
| `constcase("foo bar baz")`    | `"FOO_BAR_BAZ"` |
| `headercase("foo bar baz")`   | `"Foo-Bar-Baz"` |
| `kebabcase("foo bar baz")`    | `"foo-bar-baz"` |
| `pascalcase("foo bar baz")`   | `"FooBarBaz"`   |
| `pathcase("foo bar baz")`     | `"foo/bar/baz"` |
| `sentencecase("foo bar baz")` | `"Foo bar baz"` |
| `snakecase("foo bar baz")`    | `"foo_bar_baz"` |
| `titlecase("foo bar baz")`    | `"Foo Bar Baz"` |

## 2. API

### 2.1 configure

Use the `acronyms` keyword at initialization to add acronyms for all
case conversions.

For example, to add `HTTP` and `XML` acronyms:

```ruby
strings = Strings::Case.new(acronyms: %w[HTTP XML])
```

After initialization, use the `configure` method to add acronyms
in a block with the `acronym` method:

```ruby
strings.configure do |config|
  config.acronym "HTTP"
  config.acronym "XML"

  # or config.acronym "HTTP", "XML"
end
```

Or, use the `configure` method with the `acronyms` keyword:

```ruby
strings.configure(acronyms: %w[HTTP XML])
```

This will result in a conversion preserving acronyms:

```ruby
strings.camelcase("xml_http_request")
# => "XMLHTTPRequest"
```

### 2.2 camelcase

Use the `camelcase` method to convert a string into a camel case. It will
lowercase first and capitalise all remaining words, joining them by
removing any space. For example:

```ruby
strings.camelcase("PostgreSQL adapter")
# => "postgreSqlAdapter"
```

Use the `acronyms` keyword to preserve acronyms:

```ruby
strings.camelcase("PostgreSQL adapter", acronyms: ["PostgreSQL"])
# => "PostgreSQLAdapter"
```

### 2.3 constcase

Use the `constcase` method to convert a string into a constant case. It will
uppercase all words and separate them with an underscore `_`. For example:

```ruby
strings.constcase("PostgreSQL adapter")
# => "POSTGRE_SQL_ADAPTER"
```

Use the `acronyms` keyword to preserve acronyms:

```ruby
strings.constcase("PostgreSQL adapter", acronyms: ["PostgreSQL"])
# => "POSTGRESQL_ADAPTER"
```

### 2.4 headercase

Use the `headercase` method to convert a string into a header case. It will
capitalise all words and separate them with a hyphen `-`. For example:

```ruby
strings.headercase("PostgreSQL adapter")
# => "Postgre-Sql-Adapter"
```

Use the `acronyms` keyword to preserve acronyms:

```ruby
strings.headercase("PostgreSQL adapter", acronyms: ["PostgreSQL"])
# => "PostgreSQL-Adapter"
```

### 2.5 kebabcase | dashcase

Use the `kebabcase` or `dashcase` method to convert a string into a kebab case.
It will lowercase all words and separate them with a dash `-` like a words
kebab on a skewer. For example:

```ruby
strings.kebabcase("PostgreSQL adapter")
# => "postgre-sql-adapter"
```

Use the `acronyms` keyword to preserve acronyms:

```ruby
strings.dashcase("PostgreSQL adapter", acronyms: ["PostgreSQL"])
# => "postgresql-adapter"
```

### 2.6 pascalcase

Use the `pascalcase` method to convert a string into a Pascal case. It will
capitalise all words and join them by removing any space. For example:

```ruby
strings.pascalcase("PostgreSQL adapter")
# => "PostgreSqlAdapter"
```

Use the `acronyms` keyword to preserve acronyms:

```ruby
strings.pascalcase("PostgreSQL adapter", acronyms: ["PostgreSQL"])
# => "PostgreSQLAdapter"
```

### 2.7 pathcase

Use the `pathcase` to convert a string into a path case. It will lowercase
all words and join them with a forward slash `/`. For example:

```ruby
strings.pathcase("PostgreSQL adapter")
# => "postgre/sql/adapter"
```

Use the `acronyms` keyword to preserve acronyms:

```ruby
strings.pathcase("PostgreSQL adapter", acronyms: ["PostgreSQL"])
# => "postgresql/adapter"
```

Use the `separator` keyword to change the default forward slash `/` path
separator. For example, to use backslash `\` as a path separator:

```ruby
strings.pathcase("PostgreSQL adapter", separator: "\\")
# => "postgre\\sql\\adapter"
```

### 2.8 sentencecase

Use the `sentencecase` to convert a string into a sentence case. It will
capitalise first and lowercase all remaining words, separating them with
space. For example:

```ruby
strings.sentencecase("PostgreSQL adapter")
# => "Postgre sql adapter"
```

Use the `acronyms` keyword to preserve acronyms:

```ruby
strings.sentencecase("PostgreSQL adapter", acronyms: ["PostgreSQL"])
# => "PostgreSQL adapter"
```

### 2.9 snakecase | underscore

Use the `snakecase` or `underscore` method to convert a string into
a snake case. It will lowercase all words and separate them with
an underscore `_`. For example:

```ruby
strings.snakecase("PostgreSQL adapter")
# => "postgre_sql_adapter"
```

Use the `acronyms` keyword to preserve acronyms:

```ruby
strings.underscore("PostgreSQL adapter", acronyms: ["PostgreSQL"])
# => "postgresql_adapter"
```

### 2.10 titlecase

Use `titlecase` to convert a string into a title case. It will capitalise all
words and separate them with space. For example:

```ruby
strings.titlecase("PostgreSQL adapter")
# => "Postgre Sql Adapter"
```

Use the `acronyms` keyword to preserve acronyms:

```ruby
strings.titlecase("PostgreSQL adapter", acronyms: ["PostgreSQL"])
# => "PostgreSQL Adapter"
```

## 3. Extending String class

Polluting core Ruby classes globally may have unintended consequences.
Instead, consider adding the required methods to the `String` class
using refinements.

For example, to extend the `String` class with only the `snakecase` method:

```ruby
module MyStringExt
  refine String do
    def snakecase(*args)
      Strings::Case.snakecase(self, *args)
    end
  end
end
```

Then using refinement will make the `snakecase` method available
for any string:

```ruby
using MyStringExt

"foo bar baz".snakecase
# => "foo_bar_baz"
```

Load `Strings::Case::Extensions` refinement to extend the `String` class
with all case conversion methods:

```ruby
require "strings/case/extensions"

using Strings::Case::Extensions

"foo bar baz".camelcase
# => "fooBarBaz"

"foo bar baz".snakecase
# => "foo_bar_baz"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake spec` to run the tests. You can also run `bin/console`
for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and
then run `bundle exec rake release`, which will create a git tag for
the version, push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/piotrmurach/strings-case. This project is intended to be
a safe, welcoming space for collaboration, and contributors are expected
to adhere to the [Contributor Covenant](http://contributor-covenant.org)
code of conduct.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Strings::Case project’s codebases, issue trackers,
chat rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/piotrmurach/strings-case/blob/master/CODE_OF_CONDUCT.md).

## Copyright

Copyright (c) 2019 Piotr Murach. See LICENSE for further details.
