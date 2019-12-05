# frozen_string_literal: true

require "rspec-benchmark"
require "active_support"

RSpec.describe Strings::Case do
  include RSpec::Benchmark::Matchers

  it "changes case" do
    expect {
      Strings::Case.snakecase("fooBarBaz")
    }.to perform_slower_than {
      ActiveSupport::Inflector.underscore("fooBarBaz")
    }.at_most(2).times
  end

  it "allocates no more than 100 objects" do
    expect {
      Strings::Case.snakecase("fooBarBaz")
    }.to perform_allocation(25)
  end
end
