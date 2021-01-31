# frozen_string_literal: true

require "rspec-benchmark"
require "active_support"

RSpec.describe Strings::Case do
  include RSpec::Benchmark::Matchers

  it "changes case slower than ActiveSupport by 2x" do
    expect {
      Strings::Case.snakecase("fooBarBaz")
    }.to perform_slower_than {
      ActiveSupport::Inflector.underscore("fooBarBaz")
    }.at_most(2).times
  end

  it "changes case with acronyms as fast as ActiveSupport" do
    strings = Strings::Case.new

    strings.configure do |config|
      config.acronym "fooBar"
    end

    ActiveSupport::Inflector.inflections(:en) do |inflect|
      inflect.acronym "fooBar"
    end

    expect {
      strings.snakecase("fooBarBaz")
    }.to perform_faster_than {
      ActiveSupport::Inflector.underscore("fooBarBaz")
    }.at_least(1).times
  end

  it "allocates no more than 32 objects" do
    expect {
      Strings::Case.snakecase("fooBarBaz")
    }.to perform_allocation(32).objects
  end
end
