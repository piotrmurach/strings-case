# frozen_string_literal: true

require_relative "acronyms"

module Strings
  class Case
    # Responsible for storing acronyms configuration
    #
    # @api private
    class Configuration
      # All the registered acronyms
      #
      # @example
      #   configuration.acronyms
      #
      # @return [Strings::Case::Acronyms]
      #
      # @api public
      attr_reader :acronyms

      # Create a Configuration instance
      #
      # @example
      #   configuration = Strings::Case::Cofiguration.new
      #
      # @api public
      def initialize
        @acronyms = Acronyms.new
      end

      # Add an acronym
      #
      # @example
      #   strings = Strings::Case.new
      #   strings.configure do |config|
      #     config.acronym "HTTP"
      #   end
      #   strings.pascalcase("http_response")    # => "HTTPResponse"
      #   strings.camelcase("http_response")     # => "HTTPResponse"
      #   strings.snakecase("HTTPResponse")      # => "http_response"
      #   strings.titlecase("http_response")     # => "HTTP Response"
      #   strings.sentencecase("http_response")  # => "HTTP response"
      #
      # @param [Array<String>] names
      #   the names to add to the acronyms list
      #
      # @return [void]
      #
      # @api public
      def acronym(*names)
        names.each { |name| @acronyms << name }
      end
    end # Configuration
  end # Case
end # Strings
