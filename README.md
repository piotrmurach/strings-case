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
  * [2.8 snakecase](#28-snakecase)
  * [2.9 titlecase](#29-titlecase)
* [3. Extending String class](#3-extending-string-class)

## 1. Usage

The `Strings::Case` is a module with functions for transforming between string cases:

```ruby
Strings::Case.snakecase("foo bar baz")
# => "foo_bar_baz"
````

Here is a quick summary of available transformations:

| Case Type | Result |
| --------- | ------- |
| ```rubyStrings::Case.camelcase("foo bar baz")``` | `"fooBarBaz"` |
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

### 2.2 constcase

### 2.3 headercase

### 2.4 kebabcase | dashcase

### 2.5 pascalcase

### 2.6 pathcase

To convert a string into a file path use `pathcase`:

```ruby
Strings::Case.pathcase("HTTP response code")
# => "http/response/code"
````

To preserve the `HTTP` acronym use the `:acronyms` option:

```ruby
Strings::Case.pathcase("HTTP response code", acronyms: ["HTTP"])
# => "HTTP/response/code"
```

By default the `/` is used as a path separator. To change this use a `:sep` option. For example, on Windows the file path separator is `\`:

```ruby
Strings::Case.pathcase("HTTP response code", sep: "\\")
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

### 2.8 `snakecase`

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
