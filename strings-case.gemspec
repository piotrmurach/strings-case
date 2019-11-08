lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "strings/case/version"

Gem::Specification.new do |spec|
  spec.name          = "strings-case"
  spec.version       = Strings::Case::VERSION
  spec.authors       = ["Piotr Murach"]
  spec.email         = ["me@piotrmurach.com"]
  spec.summary       = %q{Convert strings to different cases}
  spec.description   = %q{Convert strings to different cases}
  spec.homepage      = "https://github.com/piotrmurach/strings-case"
  spec.license       = "MIT"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["changelog_uri"] = "https://github.com/piotrmurach/strings-case/blob/master/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://www.rubydoc.info/gems/strings-case"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/piotrmurach/strings-case"

  spec.files         = Dir["{lib,spec}/**/*.rb"]
  spec.files        += Dir["tasks/*", "strings-case.gemspec"]
  spec.files        += Dir["README.md", "CHANGELOG.md", "LICENSE.txt", "Rakefile"]
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.0.0"

  spec.add_development_dependency "bundler", ">= 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
end
