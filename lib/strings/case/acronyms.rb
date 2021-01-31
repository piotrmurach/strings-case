# frozen_string_literal: true

module Strings
  class Case
    # A collection of acronyms
    #
    # @api private
    class Acronyms
      # Create instance from an array of acronyms
      #
      # @param [Array<String>] acronyms
      #   the array of acronyms to add
      #
      # @api public
      def self.from(acronyms = [])
        new(acronyms)
      end

      # Mappings of downcased string to an acronym
      #
      # @example
      #   "http" => "HTTP"
      #
      # @api private
      attr_reader :entries

      # A pattern
      #
      # @api public
      attr_reader :pattern

      # Create a collection of acronyms
      #
      # @param [Array<String>] acronyms
      #   an array of acronyms
      #
      # @api public
      def initialize(acronyms = [])
        @entries = {}
        @pattern = /(?!)/ # match nothing

        acronyms.each { |acronym| add(acronym) }
      end

      # Add an acronym
      #
      # @param [String] string
      #   the string name to add to the acronyms
      #
      # @api public
      def add(string)
        @entries[string.downcase] = string
        @pattern = /#{Regexp.union(to_a)}(?=\b|[^\p{Ll}])/
      end
      alias << add

      # Find an acronym
      #
      # @param [String] string
      #   the string to search for an acronym
      #
      # @api public
      def fetch(string)
        @entries[string.downcase]
      end

      # Convert to an array of all acronyms
      #
      # @return [Array<String>]
      #
      # @api public
      def to_a
        @entries.values
      end
    end # Acronyms
  end # Case
end # Strings
