# frozen_string_literal: true

require "forwardable"
require "strscan"

require_relative "case/acronyms"
require_relative "case/configuration"
require_relative "case/version"

module Strings
  class Case
    DIGITS = ("0".."9").freeze
    UP_LETTERS = ("A".."Z").freeze
    DOWN_LETTERS = ("a".."z").freeze
    DELIMITERS = [" ", "\n", "\t", "_", ".", "-", "#", "?", "!"].freeze
    DELIMS = Regexp.union(DELIMITERS)
    NONALPHANUMERIC = (32..127).map(&:chr) -
      (DIGITS.to_a + DOWN_LETTERS.to_a + UP_LETTERS.to_a + DELIMITERS)
    NONALPHAS = Regexp.union(NONALPHANUMERIC)
    UPPERCASE = /^(\p{Ll}|\p{Digit})\p{Lu}/.freeze
    LOWERCASE = /\p{Lu}(?=\p{Ll})/.freeze

    class Error < StandardError; end

    # Global instance
    #
    # @api private
    def self.__instance__
      @__instance__ ||= Case.new
    end

    class << self
      extend Forwardable

      delegate %i[camelcase constcase constantcase dashcase
                  headercase kebabcase lower_camelcase
                  pascalcase pathcase sentencecase snakecase
                  titlecase underscore upper_camelcase] => :__instance__
    end

    # Access configuration
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
    # @yield [Configuration]
    #
    # @api public
    def configure
      yield config
    end

    # Convert string to camel case:
    # * start with a lowercase character
    # * every subsequent word has its first character uppercased
    # * all words are compounded together
    #
    # @example
    #   camelcase("foo bar baz") # => "fooBarBaz"
    #
    # @param [String] string
    #   the string to camelcase
    # @param [Array[String]] acronyms
    #   the acronyms to use to prevent modifications
    # @param [String] separator
    #   the separator for linking words, by default none
    #
    # @api public
    def camelcase(string, acronyms: [], separator: "")
      acronyms = Acronyms.from(acronyms.empty? ? config.acronyms : acronyms)
      parsecase(string, acronyms: acronyms, sep: separator) do |word, i|
        acronyms.fetch(word) || (i.zero? ? word.downcase : word.capitalize)
      end
    end
    alias lower_camelcase camelcase

    # Convert string to a constant
    #
    # @example
    #   constantcase("foo bar baz") # => "FOO_BAR_BAZ"
    #
    # @param [String] string
    #   the string to turn into constant
    # @param [Array[String]] acronyms
    #   the acronyms to use to prevent modifications
    # @param [String] separator
    #   the words separator, by default "_"
    #
    # @api public
    def constcase(string, acronyms: [], separator: "_")
      acronyms = Acronyms.from(acronyms.empty? ? config.acronyms : acronyms)
      parsecase(string, acronyms: acronyms, sep: separator, &:upcase)
    end
    alias constantcase constcase

    # Convert string to a HTTP Header
    #
    # @example
    #   headercase("foo bar baz") # = "Foo-Bar-Baz"
    #
    # @param [String] string
    #   the string to turn into header
    # @param [Array[String]] acronyms
    #   the acronyms to use to prevent modifications
    # @param [String] separator
    #   the words separator, by default "-"
    #
    # @api public
    def headercase(string, acronyms: [], separator: "-")
      acronyms = Acronyms.from(acronyms.empty? ? config.acronyms : acronyms)
      parsecase(string, acronyms: acronyms, sep: separator) do |word|
        (acronym = acronyms.fetch(word)) ? acronym : word.capitalize
      end
    end

    # Converts string to lower case words linked by hyphenes
    #
    # @example
    #   kebabcase("fooBarBaz") # => "foo-bar-baz"
    #
    #   kebabcase("__FOO_BAR__") # => "foo-bar"
    #
    # @param [String] string
    #   the string to convert to dashed string
    # @param [Array[String]] acronyms
    #   the acronyms to use to prevent modifications
    # @param [String] separator
    #   the separator for linking words, by default hyphen
    #
    # @return [String]
    #
    # @api public
    def kebabcase(string, acronyms: [], separator: "-")
      acronyms = Acronyms.from(acronyms.empty? ? config.acronyms : acronyms)
      parsecase(string, acronyms: acronyms, sep: separator, &:downcase)
    end
    alias dashcase kebabcase

    # Convert string to pascal case:
    # * every word has its first character uppercased
    # * all words are compounded together
    #
    # @example
    #   pascalcase("foo bar baz") # => "FooBarBaz"
    #
    # @param [String] string
    #   the string to convert to camel case with capital letter
    # @param [Array[String]] acronyms
    #   the acronyms to use to prevent modifications
    # @param [String] separator
    #   the separator for linking words, by default none
    #
    # @api public
    def pascalcase(string, acronyms: [], separator: "")
      acronyms = Acronyms.from(acronyms.empty? ? config.acronyms : acronyms)
      parsecase(string, acronyms: acronyms, sep: separator) do |word|
        acronyms.fetch(word) || word.capitalize
      end
    end
    alias upper_camelcase pascalcase

    # Convert string into a file path.
    #
    # By default uses `/` as a path separator.
    #
    # @example
    #   pathcase("foo bar baz") # => "foo/bar/baz"
    #
    #   pathcase("FooBarBaz") # => "foo/bar/baz"
    #
    # @param [String] string
    #   the string to convert to file path
    # @param [Array[String]] acronyms
    #   the acronyms to use to prevent modifications
    # @param [String] separator
    #   the separator for linking words, by default `/`
    #
    # @api public
    def pathcase(string, acronyms: [], separator: "/")
      acronyms = Acronyms.from(acronyms.empty? ? config.acronyms : acronyms)
      parsecase(string, acronyms: acronyms, sep: separator, &:downcase)
    end

    # Convert string into a sentence
    #
    # @example
    #   sentencecase("foo bar baz") # => "Foo bar baz"
    #
    # @param [String] string
    #   the string to convert to sentence
    # @param [Array[String]] acronyms
    #   the acronyms to use to prevent modifications
    # @param [String] separator
    #   the separator for linking words, by default a space
    #
    # @api public
    def sentencecase(string, acronyms: [], separator: " ")
      acronyms = Acronyms.from(acronyms.empty? ? config.acronyms : acronyms)
      parsecase(string, acronyms: acronyms, sep: separator) do |word, i|
        acronyms.fetch(word) || (i.zero? ? word.capitalize : word.downcase)
      end
    end

    # Convert string into a snake_case
    #
    # @example
    #   snakecase("foo bar baz") # => "foo_bar_baz"
    #
    #   snakecase("ЗдравствуйтеПривет") # => "здравствуйте_привет"
    #
    #   snakecase("HTTPResponse") # => "http_response"
    #
    # @param [String] string
    #   the string to convert to snake case
    # @param [Array[String]] acronyms
    #   the acronyms to use to prevent modifications
    # @param [String] separator
    #   the separator for linking words, by default `_`
    #
    # @api public
    def snakecase(string, acronyms: [], separator: "_")
      acronyms = Acronyms.from(acronyms.empty? ? config.acronyms : acronyms)
      parsecase(string, acronyms: acronyms, sep: separator, &:downcase)
    end
    alias underscore snakecase

    # Convert string into a title
    #
    # @example
    #   titlecase("foo bar baz") # => "Foo Bar Baz"
    #
    # @param [String] string
    #   the string to convert to title case
    # @param [Array[String]] acronyms
    #   the acronyms to use to prevent modifications
    # @param [String] separator
    #   the separator for linking words, by default a space
    #
    # @api public
    def titlecase(string, acronyms: [], separator: " ")
      acronyms = Acronyms.from(acronyms.empty? ? config.acronyms : acronyms)
      parsecase(string, acronyms: acronyms, sep: separator) do |word|
        acronyms.fetch(word) || word.capitalize
      end
    end

    private

    # Parse string and transform to desired case
    #
    # @param [String] string
    #   the string to convert to a given case
    # @param [Acronyms] acronyms
    #   the acronyms to use to parse words
    # @param [String] sep
    #   the separator for linking words, defaults to `_`
    #
    # @yield [word, index]
    #
    # @api private
    def parsecase(string, acronyms: nil, sep: "_", &conversion)
      return if string.nil?

      word_conversion =
        if conversion && conversion.arity <= 1
          ->(word, _) { conversion.(word) }
        elsif conversion
          ->(word, idx) { conversion.(word, idx) }
        else
          ->(word, _) { word }
        end

      split_into_words(string, acronyms: acronyms, sep: sep)
        .map.with_index(&word_conversion).join(sep)
    end

    # Split string into words
    #
    # @param [String] string
    #   the string to split into words
    # @param [Acronyms] acronyms
    #   the acronyms to use to split words
    # @param [String] sep
    #   the separator to use to split words
    #
    # @return [Array[String]]
    #   the split words
    #
    # @api private
    def split_into_words(string, acronyms: nil, sep: nil)
      words = []
      word = []
      scanner = StringScanner.new(string)

      while !scanner.eos?
        if scanner.match?(acronyms.pattern)
          scanner.scan(acronyms.pattern)
          words << scanner.matched
        elsif scanner.match?(UPPERCASE)
          char = scanner.getch
          word << char
          if word.size > 1 # don't allow single letter words
            words << word.join
            word = []
          end
        elsif scanner.match?(LOWERCASE)
          char = scanner.getch
          if word.size <= 1 # don't allow single letter words
            word << char
          else
            words << word.join
            word = [char]
          end
        elsif scanner.match?(DELIMS)
          char = scanner.getch
          words << word.join unless word.empty?
          if scanner.pos == 1 && char == sep
            words << ""
          elsif scanner.eos? && char == sep
            word = [""]
          else
            word = []
          end
        elsif scanner.skip(NONALPHAS)
          # noop
        else
          word << scanner.getch
        end
      end

      words << word.join unless word.empty?

      words
    end
  end # Case
end # Strings
