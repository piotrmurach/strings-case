# frozen_string_literal: true

RSpec.describe Strings::Case, ".new" do
  it "creates a global instance only once" do
    described_class.instance_variable_set(:@__instance__, nil)
    allow(described_class).to receive(:new).once.and_call_original

    described_class.camelcase("test")
    described_class.camelcase("test")

    expect(described_class).to have_received(:new).once
  end

  it "creates an instance with acronyms" do
    strings = described_class.new(acronyms: %w[HTTP XML])

    expect(strings.camelcase("xml_http_request")).to eq("XMLHTTPRequest")
  end
end
