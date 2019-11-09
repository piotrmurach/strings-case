# frozen_string_literal: true

require "benchmark/ips"
require "active_support"

require_relative "../lib/strings-case"

Benchmark.ips do |bench|
  bench.report("active_support") do
    ActiveSupport::Inflector.underscore("fooBarBaz")
  end

  bench.report("strings-case") do
    Strings::Case.snakecase("fooBarBaz")
  end

  bench.compare!
end
