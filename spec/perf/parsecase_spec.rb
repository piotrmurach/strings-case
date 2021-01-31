# frozen_string_literal: true

require "rspec-benchmark"
require "active_support"

RSpec.describe Strings::Case do
  include RSpec::Benchmark::Matchers

  it "changes case slower than ActiveSupport by 2.5x" do
    expect {
      Strings::Case.snakecase("fooBarBaz")
    }.to perform_slower_than {
      ActiveSupport::Inflector.underscore("fooBarBaz")
    }.at_most(2.5).times
  end

  it "allocates no more than 34 objects" do
    expect {
      Strings::Case.snakecase("fooBarBaz")
    }.to perform_allocation(34).objects
  end
end
