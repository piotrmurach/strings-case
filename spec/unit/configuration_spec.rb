# frozen_string_literal: true

RSpec.describe Strings::Case::Configuration do
  it "sets acronyms to the Strings::Case::Acronyms object" do
    config = described_class.new

    expect(config.acronyms).to be_a(Strings::Case::Acronyms)
  end

  it "has no acronyms configured by default" do
    config = described_class.new

    expect(config.acronyms.to_a).to eq([])
  end

  it "configures acronyms with the acronym method" do
    config = described_class.new
    config.acronym "HTTP", "XML"
    config.acronym "SQL"

    expect(config.acronyms.to_a).to eq(%w[HTTP XML SQL])
  end
end
