# frozen_string_literal: true

module Strings
  module Case
    module Extensions
      refine String do
        def camelcase(*args, **options)
          Strings::Case.camelcase(self, *args, **options)
        end
        alias lower_camelcase camelcase

        def constcase(*args, **options)
          Strings::Case.constcase(self, *args, **options)
        end
        alias constantcase constcase

        def headercase(*args, **options)
          Strings::Case.headercase(self, *args, **options)
        end

        def kebabcase(*args, **options)
          Strings::Case.kebabcase(self, *args, **options)
        end
        alias dashcase kebabcase

        def pascalcase(*args, **options)
          Strings::Case.pascalcase(self, *args, **options)
        end
        alias upper_camelcase pascalcase

        def pathcase(*args, **options)
          Strings::Case.pathcase(self, *args, **options)
        end

        def sentencecase(*args, **options)
          Strings::Case.sentencecase(self, *args, **options)
        end

        def snakecase(*args, **options)
          Strings::Case.snakecase(self, *args, **options)
        end
        alias underscore snakecase

        def titlecase(*args, **options)
          Strings::Case.titlecase(self, *args, **options)
        end
      end
    end # Extensions
  end # Case
end # Strings
