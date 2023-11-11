# frozen_string_literal: true

require "rspec-benchmark"
require "active_support"

RSpec.describe Strings::Case do
  include RSpec::Benchmark::Matchers

  it "changes case 2.85x slower than ActiveSupport" do
    expect {
      Strings::Case.snakecase("fooBarBaz")
    }.to perform_slower_than {
      ActiveSupport::Inflector.underscore("fooBarBaz")
    }.at_most(2.85).times
  end

  it "changes case with acronyms 1.3x slower than ActiveSupport" do
    strings = Strings::Case.new

    strings.configure do |config|
      config.acronym "fooBar"
    end

    ActiveSupport::Inflector.inflections(:en) do |inflect|
      inflect.acronym "fooBar"
    end

    expect {
      strings.snakecase("fooBarBaz")
    }.to perform_slower_than {
      ActiveSupport::Inflector.underscore("fooBarBaz")
    }.at_most(1.3).times
  end

  it "allocates no more than 34 objects" do
    expect {
      Strings::Case.snakecase("fooBarBaz")
    }.to perform_allocation(34).objects
  end
end
