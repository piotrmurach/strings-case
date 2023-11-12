# frozen_string_literal: true

RSpec.describe Strings::Case::Acronyms do
  it "has no acronyms by default" do
    acronyms = described_class.new

    expect(acronyms.to_a).to eq([])
  end

  it "doesn't instantiate from the Strings::Case::Acronyms object" do
    acronyms = described_class.new

    expect(described_class.from(acronyms)).to eq(acronyms)
  end

  it "creates mappings from an array of acronyms" do
    acronyms = described_class.from(%w[HTTP XML JSON])

    expect(acronyms.entries).to eq({
      "http" => "HTTP",
      "xml" => "XML",
      "json" => "JSON"
    })
  end

  it "doesn't retrieve an acronym" do
    acronyms = described_class.new

    expect(acronyms.fetch("http")).to be_nil
  end

  it "adds acronyms to the entries hash" do
    acronyms = described_class.new
    acronyms.add("HTTP")
    acronyms.add("XML")

    expect(acronyms.entries).to eq({"http" => "HTTP", "xml" => "XML"})
  end

  it "retrieves an acronym with all lowercase characters" do
    acronyms = described_class.new
    acronyms.add("HTTP")

    expect(acronyms.fetch("http")).to eq("HTTP")
  end

  it "retrieves an acronym with mixed-case characters" do
    acronyms = described_class.new
    acronyms.add("HTTP")

    expect(acronyms.fetch("HtTp")).to eq("HTTP")
  end

  ["", " ", "!"].each do |expected|
    it "matches nothing by default including #{expected.inspect}" do
      acronyms = described_class.new

      expect(acronyms.pattern).not_to match(expected)
    end
  end

  [
    "HTTP",
    "HTTPXML",
    "HTTPXMLJSON",
    "HTTP XML"
  ].each do |expected|
    it "matches #{expected.inspect} with registered acronyms" do
      acronyms = described_class.from(%w[HTTP XML JSON])

      expect(acronyms.pattern).to match(expected)
    end
  end

  [
    "HTTPs",
    "http",
    "httpxmljson",
    "HTTPxml Json"
  ].each do |expected|
    it "doesn't match #{expected.inspect} with registered acronyms" do
      acronyms = described_class.from(%w[HTTP XML JSON])

      expect(acronyms.pattern).not_to match(expected)
    end
  end
end
