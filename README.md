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

**Strings::Case** provides string case conversions for [Strings](https://github.com/piotrmurach/strings) utilities.

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

The `Strings::Case` is a class with methods for converting between string cases:

``` ruby
strings = Strings::Case.new
strings.snakecase("FooBarBaz")
# => "foo_bar_baz"
```

As a convenience, you can call methods directly on a class:

```ruby
Strings::Case.snakecase("FooBarBaz")
# => "foo_bar_baz"
````

It will transform any string into expected case:

```ruby
strings.snakecase("supports IPv6 on iOS?")
# => "supports_i_pv6_on_i_os"
```

You can also specify acronyms as a method parameter:

```ruby
strings.snakecase("supports IPv6 on iOS?", acronyms: %w[IPv6 iOS])
# => "supports_ipv6_on_ios"
```

To make acronyms available for all conversions, configure them once on an instance:

```ruby
strings.configure do |config|
  config.acronym "IPv6"
  config.acronym "iOS"
end

strings.snakecase("supports IPv6 on iOS?")
# => "supports_ipv6_on_ios"
```

It also supports converting Unicode characters:

```ruby
strings.snakecase("ЗдравствуйтеПривет")
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

### 2.1 configure

To add acronyms for all case conversions, configure them at initialization
with the `acronyms` keyword.

For example, to add `HTTP` and `XML` acronyms:

```ruby
strings = Strings::Case.new(acronyms: %w[HTTP XML])
```

After initialization, use the `configure` to add acronyms with
the `acronym` method:

```ruby
strings.configure do |config|
  config.acronym "HTTP"
  config.acronym "XML"

  # or config.acronym "HTTP", "XML"
end
```

Alternatively, use the `configure` with the `acronyms` keyword:

```ruby
strings.configure(acronyms: %w[HTTP XML])
```

This will result in a conversion preserving acronyms:

```ruby
strings.camelcase("xml_http_request")
# => "XMLHTTPRequest"
```

### 2.2 camelcase

To convert a string into a camel case, that is, a case with all the words capitilized apart from the first one and compouned together without any space use `camelcase` method. For example:

```ruby
Strings::Case.camelcase("HTTP Response Code")
# => "httpResponseCode"
```

To preserve the acronyms use the `:acronyms` option:

```ruby
Strings::Case.camelcase("HTTP Response Code", acronyms: ["HTTP"])
# => "HTTPResponseCode"
```

### 2.3 constcase

To convert a string into a constant case, that is, a case with all the words uppercased and separated by underscore character use `constcase`. For example:

```ruby
Strings::Case.constcase("HTTP Response Code")
# => "HTTP_RESPONSE_CODE"
```

### 2.4 headercase

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
### 2.5 kebabcase | dashcase

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

### 2.6 pascalcase

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

### 2.7 pathcase

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

By default the `/` is used as a path separator. To change this use a `:separator` option. For example, on Windows the file path separator is `\`:

```ruby
Strings::Case.pathcase("HTTP Response Code", separator: "\\")
# => "http\response\code"
```

### 2.8 `sentencecase`

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

### 2.9 `snakecase` | `underscore`

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

### 2.10 `titlecase`

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

For example, if you wish to only extend strings with `snakecase` method do:

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

Alternatively, to include all the **Strings::Case** methods, load extensions
in the following way:

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
