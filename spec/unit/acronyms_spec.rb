# frozen_string_literal: true

RSpec.describe Strings::Case::Acronyms do
  it "has no acronyms by default" do
    acronyms = described_class.new

    expect(acronyms.to_a).to eq([])
  end

  it "creates mappings from an array of acronyms" do
    acronyms = described_class.from(%w[HTTP XML JSON])

    expect(acronyms.entries).to eq({
      "http" => "HTTP",
      "xml" => "XML",
      "json" => "JSON"
    })
  end

  it "adds and retrieves acronyms" do
    acronyms = described_class.new

    expect(acronyms.fetch("http")).to eq(nil)

    acronyms.add("HTTP")
    acronyms.add("XML")

    expect(acronyms.entries).to eq({"http" => "HTTP", "xml" => "XML"})

    expect(acronyms.fetch("http")).to eq("HTTP")
    expect(acronyms.fetch("Xml")).to eq("XML")
  end

  it "exposes a pattern that matches nothing by default" do
    acronyms = described_class.new

    expect(acronyms.pattern).to_not match("")
    expect(acronyms.pattern).to_not match(" ")
    expect(acronyms.pattern).to_not match("!")
  end

  it "compiles pattern to match registered acronyms" do
    acronyms = described_class.from(%w[HTTP XML JSON])

    expect(acronyms.pattern).to match("HTTP")
    expect(acronyms.pattern).to match("HTTPXML")
    expect(acronyms.pattern).to match("HTTPXMLJSON")
    expect(acronyms.pattern).to match("HTTP XML")

    expect(acronyms.pattern).to_not match("HTTPs")
    expect(acronyms.pattern).to_not match("http")
    expect(acronyms.pattern).to_not match("httpxmljson")
    expect(acronyms.pattern).to_not match("HTTPxml")
  end
end
