# frozen_string_literal: true

require_relative "case/version"

module Strings
  module Case
    DIGITS = ("0".."9").freeze
    UP_LETTERS = ("A".."Z").freeze
    DOWN_LETTERS = ("a".."z").freeze
    DELIMITERS = [" ", "\n", "\t", "_", ".", "-", "#", "?", "!"].freeze
    NONALPHANUMERIC = (32..127).map(&:chr) -
      (DIGITS.to_a + DOWN_LETTERS.to_a + UP_LETTERS.to_a + DELIMITERS)
    UPCASE = /(?<!\p{Lu})\p{Lu}$/.freeze
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
    # @param [String] sep
    #   the separator for linking words, by default none
    #
    # @api public
    def camelcase(string, acronyms: [], sep: "")
      res = parsecase(string, acronyms: acronyms, sep: sep, casing: :capitalize)

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
    # @param [String] sep
    #   the words separator, by default "_"
    #
    # @api public
    def constcase(string, sep: "_")
      parsecase(string, sep: sep, casing: :upcase)
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
    # @param [String] sep
    #   the words separator, by default "-"
    #
    # @api public
    def headercase(string, acronyms: [], sep: "-")
      parsecase(string, acronyms: acronyms, sep: sep, casing: :capitalize)
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
    # @param [String] sep
    #   the separator for linking words, by default hyphen
    #
    # @return [String]
    #
    # @api public
    def kebabcase(string, acronyms: [], sep: "-")
      parsecase(string, acronyms: acronyms, sep: sep)
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
    # @api public
    def pascalcase(string, acronyms: [], sep: "")
      parsecase(string, acronyms: acronyms, sep: sep, casing: :capitalize)
    end
    module_function :pascalcase

    alias upper_camelcase pascalcase
    module_function :upper_camelcase

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
    # @param [Array[String]] acronyms
    #
    # @api public
    def snakecase(string, acronyms: [], sep: "_")
      parsecase(string, acronyms: acronyms, sep: sep)
    end
    module_function :snakecase

    alias underscore snakecase
    module_function :underscore

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
      last = string.length - 1

      string.each_char.with_index do |char, i|
        combine = word[-1].to_s + char

        if combine =~ UPCASE
          if word.size <= 1 # don't allow single letter words
            word << char
          else
            words << word.join
            word = [char]
          end
        elsif combine =~ LOWERCASE
          letter = word.pop
          if word.size <= 1 # don't allow single letter words
            word << letter << char
          else
            words << word.join
            word = [letter, char]
          end
        elsif DELIMITERS.include?(char)
          words << word.join unless word.empty?
          if i.zero? && char == sep
            words << ""
          else
            word = []
          end
        elsif NONALPHANUMERIC.include?(char)
          # noop
        else
          word << char
        end

        if last == i
          word = [""] if char == sep
          words << word.join unless word.empty?
        end
      end

      words
    end
    module_function :split_into_words
  end # Case
end # Strings
