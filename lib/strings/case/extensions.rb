# frozen_string_literal: true

module Strings
  module Case
    module Extensions
      refine String do
        def camelcase(*args)
          Strings::Case.camelcase(self, *args)
        end
        alias lower_camelcase camelcase

        def constcase(*args)
          Strings::Case.constcase(self, *args)
        end
        alias constantcase constcase

        def headercase(*args)
          Strings::Case.headercase(self, *args)
        end

        def kebabcase(*args)
          Strings::Case.kebabcase(self, *args)
        end
        alias dashcase kebabcase

        def pascalcase(*args)
          Strings::Case.pascalcase(self, *args)
        end
        alias upper_camelcase pascalcase

        def pathcase(*args)
          Strings::Case.pathcase(self, *args)
        end

        def sentencecase(*args)
          Strings::Case.sentencecase(self, *args)
        end

        def snakecase(*args)
          Strings::Case.snakecase(self, *args)
        end
        alias underscore snakecase

        def titlecase(*args)
          Strings::Case.titlecase(self, *args)
        end
      end
    end # Extensions
  end # Case
end # Strings
