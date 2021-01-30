# frozen_string_literal: true

RSpec.describe Strings::Case::Configuration do
  it "sets acronyms to an empty set" do
    config = described_class.new

    expect(config.acronyms).to eq(Set.new)
  end

  it "configures acronyms" do
    config = described_class.new
    config.acronym "HTTP", "XML"
    config.acronym "SQL"

    expect(config.acronyms.to_a).to eq(%w[HTTP XML SQL])
  end

  it "yields configuration instance" do
    strings = Strings::Case.new

    expect { |block|
      strings.configure(&block)
    }.to yield_with_args(strings.config)
  end
end
