# frozen_string_literal: true

require_relative "acronyms"

module Strings
  class Case
    # A configuration object used by a Strings::Case instance
    #
    # @api private
    class Configuration
      # All the registered acronyms
      #
      # @api public
      attr_reader :acronyms

      # Create a configuration
      #
      # @api public
      def initialize
        @acronyms = Acronyms.new
      end

      # Add an acronym
      #
      # @example
      #   strings = Strings::Case.new
      #
      #   cases.configure do |config|
      #     config.acronym "HTTP"
      #   end
      #
      #   strings.pascalcase("http_response")    # => "HTTPResponse"
      #   strings.camelcase("http_response")     # => "HTTPResponse"
      #   strings.snakecase("HTTPResponse")      # => "http_response"
      #   strings.titlecase("http_response")     # => "HTTP Response"
      #   strings.sentencecase("http_response")  # => "HTTP response"
      #
      # @param [Array<String>] names
      #   the names to add to the acronyms list
      #
      # @api public
      def acronym(*names)
        names.each { |name| @acronyms << name }
      end
    end # Configuration
  end # Case
end # Strings
