# Change log

## [v0.4.0] - 2023-11-19

### Added
* Add the ability to configure acronyms on an instance

### Changed
* Change Strings::Case to be a class to allow instantiation
* Change all conversions to apply acronyms configured on an instance
* Change all conversions to preserve non-alphanumeric characters
* Change all conversions to allow for one-letter words
* Change gemspec to only package the source files and documentation
* Change parsecase method to improve performance
* Change extensions to require core library when loaded
* Change Strings::Case class to hide constants
* Change Strings::Case class to hide instance method

## [v0.3.0] - 2019-12-07

### Added
* Add performance tests

### Changed
* Change to double parsing speed and halve object allocations

## [v0.2.0] - 2019-11-23

### Fixed
* Fix Ruby 2.7 keyword argument warnings

## [v0.1.0] - 2019-11-11

* Initial implementation and release

[v0.4.0]: https://github.com/piotrmurach/strings-case/compare/v0.3.0...v0.4.0
[v0.3.0]: https://github.com/piotrmurach/strings-case/compare/v0.2.0...v0.3.0
[v0.2.0]: https://github.com/piotrmurach/strings-case/compare/v0.1.0...v0.2.0
[v0.1.0]: https://github.com/piotrmurach/strings-case/compare/03679ef...v0.1.0
