source "https://rubygems.org"

gemspec

group :test do
  gem "activesupport"
  gem "benchmark-ips", "~> 2.7.2"
  gem "simplecov", "~> 0.16.1"
  gem "coveralls", "~> 0.8.22"
  if RUBY_VERSION.split(".")[1].to_i > 0
    gem "rspec-benchmark"
  end
end

group :metrics do
  gem "yardstick", "~> 0.9.9"
end
