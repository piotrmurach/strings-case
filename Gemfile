source "https://rubygems.org"

gemspec

group :test do
  gem "activesupport"
  gem "benchmark-ips", "~> 2.7.2"
  gem "simplecov", "~> 0.16.1"
  gem "coveralls", "~> 0.8.22"
  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("2.1.0")
    gem "rspec-benchmark"
  end
  gem "json", "2.4.1" if RUBY_VERSION == "2.0.0"
end

group :metrics do
  gem "yardstick", "~> 0.9.9"
end
