# frozen_string_literal: true

require "forwardable"
require "strscan"

require_relative "case/acronyms"
require_relative "case/configuration"
require_relative "case/version"

module Strings
  # Responsible for converting strings to common cases
  #
  # @api public
  class Case
    # The word delimiters
    #
    # @return [Array<String>]
    #
    # @api private
    DELIMITERS = [" ", "\n", "\t", "_", ".", "-", "#", "?", "!"].freeze
    private_constant :DELIMITERS

    # The pattern to detect word delimiters
    #
    # @return [Regexp]
    #
    # @api private
    DELIMS = Regexp.union(DELIMITERS)
    private_constant :DELIMS

    # The pattern to detect uppercase characters
    #
    # @return [Regexp]
    #
    # @api private
    UPPERCASE = /^(\p{Ll}|\p{Digit})\p{Lu}/.freeze
    private_constant :UPPERCASE

    # The pattern to detect lowercase characters
    #
    # @return [Regexp]
    #
    # @api private
    LOWERCASE = /\p{Lu}(?=\p{Ll})/.freeze
    private_constant :LOWERCASE

    class Error < StandardError; end

    # Global instance
    #
    # @return [Strings::Case]
    #
    # @api private
    def self.__instance__
      @__instance__ ||= Case.new
    end
    private_class_method :__instance__

    class << self
      extend Forwardable

      delegate %i[camelcase constcase constantcase dashcase
                  headercase kebabcase lower_camelcase
                  pascalcase pathcase sentencecase snakecase
                  titlecase underscore upper_camelcase] => :__instance__
    end

    # Create a Strings::Case instance
    #
    # @example
    #   strings = Strings::Case.new(acronyms: %w[HTTP XML])
    #
    # @param [Array<String>] acronyms
    #   the acronyms to use to prevent modifications
    #
    # @api public
    def initialize(acronyms: nil)
      configure(acronyms: acronyms)
    end

    # Access configuration
    #
    # @example
    #   strings.config
    #
    # @return [Strings::Case::Configuration]
    #
    # @api public
    def config
      @config ||= Configuration.new
    end

    # Configure acronyms
    #
    # @example
    #   strings = Strings::Case.new
    #   strings.configure do |config|
    #     config.acronym "HTTP"
    #   end
    #
    # @example
    #   strings = Strings::Case.new
    #   strings.configure(acronyms: %w[HTTP XML])
    #
    # @param [Array<String>] acronyms
    #   the acronyms to use to prevent modifications
    #
    # @yield [Strings::Case::Configuration]
    #
    # @return [void]
    #
    # @api public
    def configure(acronyms: nil)
      if block_given?
        yield config
      else
        config.acronym(*acronyms)
      end
    end

    # Convert string to camel case
    #
    # @example
    #   camelcase("foo bar baz") # => "fooBarBaz"
    #
    # @param [String] string
    #   the string to convert to camel case
    # @param [Array<String>] acronyms
    #   the acronyms to use to prevent modifications
    # @param [String] separator
    #   the words separator, by default an empty string
    #
    # @return [String]
    #
    # @api public
    def camelcase(string, acronyms: config.acronyms, separator: "")
      acronyms = Acronyms.from(acronyms)
      parsecase(string, acronyms: acronyms, sep: separator) do |word, i|
        acronyms.fetch(word) || (i.zero? ? word.downcase : word.capitalize)
      end
    end
    alias lower_camelcase camelcase

    # Convert string to constant case
    #
    # @example
    #   constantcase("foo bar baz") # => "FOO_BAR_BAZ"
    #
    # @param [String] string
    #   the string to convert to constant case
    # @param [Array<String>] acronyms
    #   the acronyms to use to prevent modifications
    # @param [String] separator
    #   the words separator, by default an underscore "_"
    #
    # @return [String]
    #
    # @api public
    def constcase(string, acronyms: config.acronyms, separator: "_")
      acronyms = Acronyms.from(acronyms)
      parsecase(string, acronyms: acronyms, sep: separator, &:upcase)
    end
    alias constantcase constcase

    # Convert string to header case
    #
    # @example
    #   headercase("foo bar baz") # = "Foo-Bar-Baz"
    #
    # @param [String] string
    #   the string to convert to header case
    # @param [Array<String>] acronyms
    #   the acronyms to use to prevent modifications
    # @param [String] separator
    #   the words separator, by default a hyphen "-"
    #
    # @return [String]
    #
    # @api public
    def headercase(string, acronyms: config.acronyms, separator: "-")
      acronyms = Acronyms.from(acronyms)
      parsecase(string, acronyms: acronyms, sep: separator) do |word|
        (acronym = acronyms.fetch(word)) ? acronym : word.capitalize
      end
    end

    # Convert string to kebab case
    #
    # @example
    #   kebabcase("fooBarBaz") # => "foo-bar-baz"
    #
    # @example
    #   kebabcase("__FOO_BAR__") # => "foo-bar"
    #
    # @param [String] string
    #   the string to convert to kebab case
    # @param [Array<String>] acronyms
    #   the acronyms to use to prevent modifications
    # @param [String] separator
    #   the words separator, by default a hyphen "-"
    #
    # @return [String]
    #
    # @api public
    def kebabcase(string, acronyms: config.acronyms, separator: "-")
      acronyms = Acronyms.from(acronyms)
      parsecase(string, acronyms: acronyms, sep: separator, &:downcase)
    end
    alias dashcase kebabcase

    # Convert string to Pascal case
    #
    # @example
    #   pascalcase("foo bar baz") # => "FooBarBaz"
    #
    # @param [String] string
    #   the string to convert to Pascal case
    # @param [Array<String>] acronyms
    #   the acronyms to use to prevent modifications
    # @param [String] separator
    #   the words separator, by default an empty string
    #
    # @return [String]
    #
    # @api public
    def pascalcase(string, acronyms: config.acronyms, separator: "")
      acronyms = Acronyms.from(acronyms)
      parsecase(string, acronyms: acronyms, sep: separator) do |word|
        acronyms.fetch(word) || word.capitalize
      end
    end
    alias upper_camelcase pascalcase

    # Convert string to path case
    #
    # @example
    #   pathcase("foo bar baz") # => "foo/bar/baz"
    #
    # @example
    #   pathcase("FooBarBaz") # => "foo/bar/baz"
    #
    # @param [String] string
    #   the string to convert to path case
    # @param [Array<String>] acronyms
    #   the acronyms to use to prevent modifications
    # @param [String] separator
    #   the words separator, by default a forward slash "/"
    #
    # @return [String]
    #
    # @api public
    def pathcase(string, acronyms: config.acronyms, separator: "/")
      acronyms = Acronyms.from(acronyms)
      parsecase(string, acronyms: acronyms, sep: separator, &:downcase)
    end

    # Convert string to sentence case
    #
    # @example
    #   sentencecase("foo bar baz") # => "Foo bar baz"
    #
    # @param [String] string
    #   the string to convert to sentence case
    # @param [Array<String>] acronyms
    #   the acronyms to use to prevent modifications
    # @param [String] separator
    #   the words separator, by default a space
    #
    # @return [String]
    #
    # @api public
    def sentencecase(string, acronyms: config.acronyms, separator: " ")
      acronyms = Acronyms.from(acronyms)
      parsecase(string, acronyms: acronyms, sep: separator) do |word, i|
        acronyms.fetch(word) || (i.zero? ? word.capitalize : word.downcase)
      end
    end

    # Convert string to snake case
    #
    # @example
    #   snakecase("foo bar baz") # => "foo_bar_baz"
    #
    # @example
    #   snakecase("ЗдравствуйтеПривет") # => "здравствуйте_привет"
    #
    # @example
    #   snakecase("HTTPResponse") # => "http_response"
    #
    # @param [String] string
    #   the string to convert to snake case
    # @param [Array<String>] acronyms
    #   the acronyms to use to prevent modifications
    # @param [String] separator
    #   the words separator, by default an underscore "_"
    #
    # @return [String]
    #
    # @api public
    def snakecase(string, acronyms: config.acronyms, separator: "_")
      acronyms = Acronyms.from(acronyms)
      parsecase(string, acronyms: acronyms, sep: separator, &:downcase)
    end
    alias underscore snakecase

    # Convert string to title case
    #
    # @example
    #   titlecase("foo bar baz") # => "Foo Bar Baz"
    #
    # @param [String] string
    #   the string to convert to title case
    # @param [Array<String>] acronyms
    #   the acronyms to use to prevent modifications
    # @param [String] separator
    #   the words separator, by default a space
    #
    # @return [String]
    #
    # @api public
    def titlecase(string, acronyms: config.acronyms, separator: " ")
      acronyms = Acronyms.from(acronyms)
      parsecase(string, acronyms: acronyms, sep: separator) do |word|
        acronyms.fetch(word) || word.capitalize
      end
    end

    private

    # Parse string and transform to desired case
    #
    # @param [String] string
    #   the string to convert to a given case
    # @param [Strings::Case::Acronyms] acronyms
    #   the acronyms to use to parse words
    # @param [String] sep
    #   the words separator, by default an underscore "_"
    #
    # @yield [word, index]
    #
    # @return [String]
    #
    # @api private
    def parsecase(string, acronyms: nil, sep: "_", &conversion)
      return if string.nil?

      none_or_index = conversion.arity <= 1 ? :map : :with_index
      split_into_words(string, acronyms: acronyms, sep: sep)
        .map.send(none_or_index, &conversion).join(sep)
    end

    # Split string into words
    #
    # @param [String] string
    #   the string to split into words
    # @param [Strings::Case::Acronyms] acronyms
    #   the acronyms to use to split words
    # @param [String] sep
    #   the separator to use to split words
    #
    # @return [Array<String>]
    #   the split words
    #
    # @api private
    def split_into_words(string, acronyms: nil, sep: nil)
      words = []
      word = []
      scanner = StringScanner.new(string)

      while !scanner.eos?
        if scanner.match?(acronyms.pattern)
          unless word.empty?
            words << word.join
            word.clear
          end
          scanner.scan(acronyms.pattern)
          words << scanner.matched
        elsif scanner.match?(UPPERCASE)
          char = scanner.getch
          word << char
          words << word.join
          word.clear
        elsif scanner.match?(LOWERCASE)
          char = scanner.getch
          words << word.join unless word.empty?
          word = [char]
        elsif scanner.match?(DELIMS)
          char = scanner.getch
          words << word.join unless word.empty?
          if scanner.pos == 1 && char == sep
            words << ""
          elsif scanner.eos? && char == sep
            word = [""]
          else
            word.clear
          end
        else
          word << scanner.getch
        end
      end

      words << word.join unless word.empty?

      words
    end
  end # Case
end # Strings
