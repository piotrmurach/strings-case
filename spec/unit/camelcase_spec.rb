# frozen_string_literal: true

RSpec.describe Strings::Case, "#camelcase" do
  {
    nil => nil,
    "" => "",
    "f" => "f",
    "1234" => "1234",
    "FOO" => "foo",
    "FooBar" => "fooBar",
    "fooBar" => "fooBar",
    "foo bar" => "fooBar",
    "Foo - Bar" => "fooBar",
    "foo & bar" => "fooBar",
    "FooFooBar" => "fooFooBar",
    "Foo2Foo2Bar" => "foo2Foo2Bar",
    "foo-bar-baz" => "fooBarBaz",
    "foo_bar_1_2" => "fooBar12",
    "_foo_bar_baz_" => "fooBarBaz",
    "--foo-bar--" => "fooBar",
    "FOO_BAR_baz" => "fooBarBaz",
    "__FOO_BAR__" => "fooBar",
    "Foo w1th apo's and punc]t" => "fooW1thAposAndPunct",
    "getHTTPResponse" => "getHttpResponse",
    "currencyISOCode" => "currencyIsoCode",
    "get2HTTPResponse" => "get2HttpResponse",
    "HTTPResponseCode" => "httpResponseCode",
    "HTTPResponseCodeXY" => "httpResponseCodeXy",
    "supports IPv6 on iOS?" =>  "supportsIpv6OnIos"
  }.each do |actual, expected|
    it "applies camelcase to #{actual.inspect} -> #{expected.inspect}" do
      expect(Strings::Case.camelcase(actual)).to eq(expected)
    end
  end

  it "supports unicode", if: modern_ruby? do
    expect(Strings::Case.camelcase("ЗдравствуйтеПривет")).to eq("здравствуйтеПривет")
  end

  it "allows to preserve acronyms" do
    camelized = Strings::Case.lower_camelcase("HTTP response code", acronyms: ["HTTP"])

    expect(camelized).to eq("HTTPResponseCode")
  end

  it "changes a separator to :" do
    camelized = Strings::Case.camelcase("HTTP response code", separator: ":")

    expect(camelized).to eq("http:Response:Code")
  end

  it "configures acronyms on an instance method" do
    casing = Strings::Case.new
    camelized = casing.camelcase("HTTP response code", acronyms: %w[HTTP])

    expect(camelized).to eq("HTTPResponseCode")
  end
end
