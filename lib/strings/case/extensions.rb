# frozen_string_literal: true

require_relative "../case"

module Strings
  class Case
    # Responsible for refining the String class with case conversions
    #
    # @api public
    module Extensions
      refine String do
        # Convert string to camel case
        #
        # @see Strings::Case#camelcase
        #
        # @api public
        def camelcase(*args, **options)
          Strings::Case.camelcase(self, *args, **options)
        end
        alias_method :lower_camelcase, :camelcase

        # Convert string to constant case
        #
        # @see Strings::Case#constcase
        #
        # @api public
        def constcase(*args, **options)
          Strings::Case.constcase(self, *args, **options)
        end
        alias_method :constantcase, :constcase

        # Convert string to an HTTP header
        #
        # @see Strings::Case#headercase
        #
        # @api public
        def headercase(*args, **options)
          Strings::Case.headercase(self, *args, **options)
        end

        # Convert string to lowercase words linked by hyphens
        #
        # @see Strings::Case#kebabcase
        #
        # @api public
        def kebabcase(*args, **options)
          Strings::Case.kebabcase(self, *args, **options)
        end
        alias_method :dashcase, :kebabcase

        # Convert string to pascal case
        #
        # @see Strings::Case#pascalcase
        #
        # @api public
        def pascalcase(*args, **options)
          Strings::Case.pascalcase(self, *args, **options)
        end
        alias_method :upper_camelcase, :pascalcase

        # Convert string to file path case
        #
        # @see Strings::Case#pathcase
        #
        # @api public
        def pathcase(*args, **options)
          Strings::Case.pathcase(self, *args, **options)
        end

        # Convert string to sentence case
        #
        # @see Strings::Case#sentencecase
        #
        # @api public
        def sentencecase(*args, **options)
          Strings::Case.sentencecase(self, *args, **options)
        end

        # Convert string to snake case
        #
        # @see Strings::Case#snakecase
        #
        # @api public
        def snakecase(*args, **options)
          Strings::Case.snakecase(self, *args, **options)
        end
        alias_method :underscore, :snakecase

        # Convert string to title case
        #
        # @see Strings::Case#titlecase
        #
        # @api public
        def titlecase(*args, **options)
          Strings::Case.titlecase(self, *args, **options)
        end
      end
    end # Extensions
  end # Case
end # Strings
