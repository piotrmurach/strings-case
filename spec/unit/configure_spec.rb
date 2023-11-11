# frozen_string_literal: true

RSpec.describe Strings::Case, "#configure" do
  it "configures acronyms within a block" do
    strings = described_class.new

    strings.configure do |config|
      config.acronym "HTTP", "JSON"
      config.acronym "XML"
    end

    expect(strings.camelcase("xml_http_request")).to eq("XMLHTTPRequest")
  end

  it "configures acronyms with a keyword parameter" do
    strings = described_class.new
    acronyms = %w[HTTP XML]

    strings.configure(acronyms: acronyms)

    expect(strings.camelcase("xml_http_request")).to eq("XMLHTTPRequest")
  end

  it "overrides acronyms configuration in a method" do
    strings = described_class.new

    strings.configure do |config|
      config.acronym "HTTP", "XML"
    end

    camelized = strings.camelcase("xml_http_request", acronyms: %w[XML])
    expect(camelized).to eq("XMLHttpRequest")
  end
end
