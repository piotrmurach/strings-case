source "https://rubygems.org"

gemspec

group :test do
  gem "benchmark-ips", "~> 2.7.2"
  gem "json", "2.4.1" if RUBY_VERSION == "2.0.0"
  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("2.1.0")
    gem "rspec-benchmark"
  end
  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("2.7.0")
    gem "activesupport", "~> 7.1.2"
    gem "coveralls_reborn", "~> 0.28.0"
    gem "rubocop-performance", "~> 1.19"
    gem "rubocop-rake", "~> 0.6.0"
    gem "simplecov", "~> 0.22.0"
  end
end

group :metrics do
  gem "yardstick", "~> 0.9.9"
end
