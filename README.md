<div align="center">
  <img width="225" src="https://github.com/piotrmurach/strings/blob/master/assets/strings_logo.png" alt="strings logo" />
</div>

# Strings::Case

[![Gem Version](https://badge.fury.io/rb/strings-case.svg)][gem]
[![Build Status](https://secure.travis-ci.org/piotrmurach/strings-case.svg?branch=master)][travis]
[![Build status](https://ci.appveyor.com/api/projects/status/yr87c96wxp1cw2ep?svg=true)][appveyor]
[![Maintainability](https://api.codeclimate.com/v1/badges/7938258c4af196a19843/maintainability)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/github/piotrmurach/strings-case/badge.svg?branch=master)][coverage]
[![Inline docs](http://inch-ci.org/github/piotrmurach/strings-case.svg?branch=master)][inchpages]

[gem]: http://badge.fury.io/rb/strings-case
[travis]: http://travis-ci.org/piotrmurach/strings-case
[appveyor]: https://ci.appveyor.com/project/piotrmurach/strings-case
[codeclimate]: https://codeclimate.com/github/piotrmurach/strings-case/maintainability
[coverage]: https://coveralls.io/github/piotrmurach/strings-case?branch=master
[inchpages]: http://inch-ci.org/github/piotrmurach/strings-case

> Convert strings to different cases.

**Strings::Case** provides string case conversions for [Strings](https://github.com/piotrmurach/strings) utilities.

## Motivation

Popular solutions that deal with transforming string cases work well in simple cases.(Sorry ;-) With more complex strings you may get unexpected results:

```ruby
ActiveSupport::Inflector.underscore("supports IPv6 on iOS?")
# => "supports i_pv6 on i_os?"
```

In contrast, `Strings::Case` aims to be able to transform any string to expected case:

```ruby
Strings::Case.underscore("supports IPv6 on iOS?")
# => "supports_ipv6_on_ios"
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'strings-case'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install strings-case


## Features

* No monkey-patching String class
* Converts any string to specified case
* Supports Unicode characters

## Contents

* [1. Usage](#1-usage)
* [2. API](#2-api)
  * [2.1 camelcase](#21-camelcase)
  * [2.2 constcase](#22-constcase)
  * [2.3 headercase](#23-headercase)
  * [2.4 kebabcase | dashcase](#24-kebabcase--dashcase)
  * [2.5 pascalcase](#25-pascalcase)
  * [2.6 pathcase](#26-pathcase)
  * [2.7 sentencecase](#27-sentencecase)
  * [2.8 snakecase | underscore](#28-snakecase--underscore)
  * [2.9 titlecase](#29-titlecase)
* [3. Extending String class](#3-extending-string-class)

## 1. Usage

The `Strings::Case` is a module with functions for transforming between string cases:

```ruby
Strings::Case.snakecase("foo bar baz")
# => "foo_bar_baz"
````

It will transform any string into expected case:

```ruby
Strings::Case.snake_case("supports IPv6 on iOS?")
# => "supports_ipv6_on_ios"
```

You can apply case transformations to Unicode characters:

```ruby
Strings::Case.snake_case("ЗдравствуйтеПривет")
# => "здравствуйте_привет"
```

Here is a quick summary of available transformations:

| Case Type | Result |
| --------- | ------- |
| ```Strings::Case.camelcase("foo bar baz")``` | `"fooBarBaz"` |
| ```Strings::Case.constcase("foo bar baz")``` | `"FOO_BAR_BAZ"` |
| ```Strings::Case.headercase("foo bar baz")``` | `"Foo-Bar-Baz"` |
| ```Strings::Case.kebabcase("foo bar baz")``` | `"foo-bar-baz"` |
| ```Strings::Case.pascalcase("foo bar baz")``` | `"FooBarBaz"` |
| ```Strings::Case.pathcase("foo bar baz")``` | `"foo/bar/baz"` |
| ```Strings::Case.sentencecase("foo bar baz")``` | `"Foo bar baz"` |
| ```Strings::Case.snakecase("foo bar baz")``` | `"foo_bar_baz"` |
| ```Strings::Case.titlecase("foo bar baz")``` | `"Foo Bar Baz"` |

## 2. API

### 2.1 camelcase

To convert a string into a camel case, that is, a case with all the words capitilized apart from the first one and compouned together without any space use `camelase` method. For example:

```ruby
Strings::Case.camelcase("HTTP Response Code")
# => "httpResponseCode"
```

To preserve the acronyms use the `:acronyms` option:

```ruby
Strings::Case.camelcase("HTTP Response Code", acronyms: ["HTTP"])
# => "HTTPResponseCode"
```

### 2.2 constcase

To convert a string into a constant case, that is, a case with all the words uppercased and separated by underscore character use `constcase`. For example:

```ruby
Strings::Case.constcase("HTTP Response Code")
# => "HTTP_RESPONSE_CODE"
```

### 2.3 headercase

To covert a string into a header case, that is, a case with all the words capitalized and separated by a hypen use `headercase`. For example:

```ruby
Strings::Case.headercase("HTTP Response Code")
# => "Http-Response-Code"
```

To preserve the acronyms use the `:acronyms` option:

```ruby
Strings::Case.headercase("HTTP Response Code", acronyms: ["HTTP"])
# => "HTTP-Response-Code"
```
### 2.4 kebabcase | dashcase

To convert a string into a kebab case, that is, a case with all the words lowercased and separted by a dash, like a words kebabab on a skewer, use `kebabcase` or `dashcase` methods. For example:

```ruby
Strings::Case.kebabcase("HTTP Response Code")
# => "http-response-code"
```

To preserve the acronyms use the `:acronyms` option:

```ruby
Strings::Case.dashcase("HTTP Response Code", acronyms: ["HTTP"])

expect(dashed).to eq("HTTP-response-code")
```

### 2.5 pascalcase

To convert a string into a pascal case, that is, a case with all the words capitilized and compounded together without a space, use `pascalcase` method. For example:

```ruby
Strings::Case.pascalcase("HTTP Response Code")
# => "HttpResponseCode"
```

To preserve the acronyms use the `:acronyms` option:

```ruby
Strings::Case.pascalcase("HTTP Response Code")
# => "HTTPResponseCode"
```

### 2.6 pathcase

To convert a string into a file path use `pathcase`:

```ruby
Strings::Case.pathcase("HTTP Response Code")
# => "http/response/code"
````

To preserve the acronyms use the `:acronyms` option:

```ruby
Strings::Case.pathcase("HTTP Response Code", acronyms: ["HTTP"])
# => "HTTP/response/code"
```

By default the `/` is used as a path separator. To change this use a `:sep` option. For example, on Windows the file path separator is `\`:

```ruby
Strings::Case.pathcase("HTTP Response Code", separator: "\\")
# => "http\response\code"
```

### 2.7 `sentencecase`

To turn a string into a sentence use `sentencecase`:

```ruby
Strings::Case.sentencecase("HTTP Response Code")
# => "Http response code"
```

To preserve the `HTTP` acronym use the `:acronyms` option:

```ruby
Strings::Case.sentencecase("HTTP Response Code", acronyms: ["HTTP"])
# => "HTTP response code"
```

### 2.8 `snakecase` | `underscore`

To convert a string into a snake case by lowercasing all the characters and separating them with an `_` use `snakecase` or `underscore` methods. For example:

```ruby
Strings::Case.snakecase("HTTP Response Code")
# => "http_response_code"
```

To preserve acronyms in your string use the `:acronyms` option. For example:

```ruby
Strings::Case.snakecase("HTTP Response Code", acronyms: ["HTTP"])
# => "HTTP_response_code"
```

### 2.9 `titlecase`

To convert a string into a space delimited words that have their first letter capitalized use `titlecase`. For example:

```ruby
Strings::Case.titlecase("HTTPResponseCode")
# => "Http Response Code"
```

To preserve the `HTTP` acronym use the `:acronyms` option:

```ruby
Strings::Case.titlecase("HTTP response code", acronyms: ["HTTP"])
# => "HTTP Response Code"
```

## 3. Extending String class

Though it is highly discouraged to pollute core Ruby classes, you can add the required methods to `String` class by using refinements.

For example, if you wish to only extend strings with `wrap` method do:

```ruby
module MyStringExt
  refine String do
    def snakecase(*args)
      Strings::Case.snakecase(self, *args)
    end
  end
end
```

Then `snakecase` method will be available for any strings where refinement is applied:

```ruby
using MyStringExt

"foo bar baz".snakecase
# => "foo_bar_baz"
```

However, if you want to include all the **Strings::Case** methods, you can use provided extensions file:

```ruby
require "strings/case/extensions"

using Strings::Case::Extensions
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/piotrmurach/strings-case. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Strings::Case project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/piotrmurach/strings-case/blob/master/CODE_OF_CONDUCT.md).

## Copyright

Copyright (c) 2019 Piotr Murach. See LICENSE for further details.
