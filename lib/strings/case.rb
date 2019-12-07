# frozen_string_literal: true

require "strscan"

require_relative "case/version"

module Strings
  module Case
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

    # Prevent changing case
    module NullCase
      def downcase
        self
      end
      alias upcase downcase
      alias capitalize downcase
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
      res = parsecase(string, acronyms: acronyms, sep: separator, casing: :capitalize)

      return res if res.to_s.empty?

      acronyms_regex = /^(#{acronyms.join("|")})/
      if !acronyms.empty? && (res =~ acronyms_regex)
        res
      else
        res[0].downcase + res[1..-1]
      end
    end
    module_function :camelcase

    alias lower_camelcase camelcase
    module_function :lower_camelcase

    # Converts string to a constant
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
    def constcase(string, separator: "_")
      parsecase(string, sep: separator, casing: :upcase)
    end
    module_function :constcase

    alias constantcase constcase
    module_function :constantcase

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
      parsecase(string, acronyms: acronyms, sep: separator, casing: :capitalize)
    end
    module_function :headercase

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
      parsecase(string, acronyms: acronyms, sep: separator)
    end
    module_function :kebabcase

    alias dashcase kebabcase
    module_function :dashcase

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
      parsecase(string, acronyms: acronyms, sep: separator, casing: :capitalize)
    end
    module_function :pascalcase

    alias upper_camelcase pascalcase
    module_function :upper_camelcase

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
      parsecase(string, acronyms: acronyms, sep: separator)
    end
    module_function :pathcase

    # Convert string int a sentence
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
      res = parsecase(string, acronyms: acronyms, sep: separator, casing: :downcase)

      return res if res.to_s.empty?

      res[0].upcase + res[1..-1]
    end
    module_function :sentencecase

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
      parsecase(string, acronyms: acronyms, sep: separator)
    end
    module_function :snakecase

    alias underscore snakecase
    module_function :underscore

    # Convert string into a title case
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
      parsecase(string, acronyms: acronyms, sep: separator, casing: :capitalize)
    end
    module_function :titlecase

    # Parse string and transform to desired case
    #
    # @api private
    def parsecase(string, acronyms: [], sep: "_", casing: :downcase)
      return if string.nil?

      words = split_into_words(string, sep: sep)

      no_case = ->(w) { acronyms.include?(w) ? w.extend(NullCase) : w }

      words
        .map(&no_case)
        .map(&casing)
        .join(sep)
    end
    module_function :parsecase
    private_class_method :parsecase

    # Split string into words
    #
    # @return [Array[String]]
    #   the split words
    #
    # @api private
    def split_into_words(string, sep: nil)
      words = []
      word = []
      scanner = StringScanner.new(string)

      while !scanner.eos?
        if scanner.match?(UPPERCASE)
          char = scanner.getch
          if word.size <= 1 # don't allow single letter words
            word << char
          else
            word << char
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
    module_function :split_into_words
  end # Case
end # Strings
