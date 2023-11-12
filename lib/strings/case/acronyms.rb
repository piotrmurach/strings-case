# frozen_string_literal: true

module Strings
  class Case
    # A collection of acronyms
    #
    # @api private
    class Acronyms
      # Create instance from an array of acronyms
      #
      # @example
      #   acronyms = Strings::Case::Acronyms.new(%w[HTTP XML])
      #
      # @param [Array<String>, Strings::Case::Acronyms] acronyms
      #   the acronyms to add
      #
      # @return [Strings::Case::Acronyms]
      #
      # @api public
      def self.from(acronyms = [])
        return acronyms if acronyms.is_a?(self)

        new(acronyms)
      end

      # Mappings of downcased string to an acronym
      #
      # @example
      #   acronyms.entries
      #   # => {"http" => "HTTP"}
      #
      # @return [Hash{String => String}]
      #
      # @api private
      attr_reader :entries

      # A pattern
      #
      # @example
      #   acronyms.pattern
      #
      # @return [Regexp]
      #
      # @api public
      attr_reader :pattern

      # Create an Acronyms instance
      #
      # @example
      #   acronyms = Strings::Case::Acronyms.new(%w[HTTP XML])
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
      # @example
      #   acronyms.add("HTTP")
      #
      # @example
      #   acronyms << "HTTP"
      #
      # @param [String] string
      #   the string name to add to the acronyms
      #
      # @return [void]
      #
      # @api public
      def add(string)
        @entries[string.downcase] = string
        @pattern = /#{Regexp.union(to_a)}(?=\b|[^\p{Ll}])/
      end
      alias << add

      # Find an acronym
      #
      # @example
      #   acronyms.fetch("http")
      #
      # @param [String] string
      #   the string to search for an acronym
      #
      # @return [String]
      #
      # @api public
      def fetch(string)
        @entries[string.downcase]
      end

      # Convert to an array of all acronyms
      #
      # @example
      #   acronyms.to_a
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
