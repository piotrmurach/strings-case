# frozen_string_literal: true

RSpec.describe Strings::Case, "#sentencecase" do
  {
    nil => nil,
    "" => "",
    "f" => "F",
    "1234" => "1234",
    "FOO" => "Foo",
    "FooBar" => "Foo bar",
    "fooBar" => "Foo bar",
    "foo bar" => "Foo bar",
    "Foo - Bar" => "Foo bar",
    "foo & bar" => "Foo bar",
    "FooFooBar" => "Foo foo bar",
    "Foo2Foo2Bar" => "Foo2 foo2 bar",
    "foo-bar-baz" => "Foo bar baz",
    "foo_bar_1_2" => "Foo bar 1 2",
    "_foo_bar_baz_" => "Foo bar baz",
    "--foo-bar--" => "Foo bar",
    "FOO_BAR_baz" => "Foo bar baz",
    "__FOO_BAR__" => "Foo bar",
    "Foo w1th apo's and punc]t" => "Foo w1th apos and punct",
    "getHTTPResponse" => "Get http response",
    "currencyISOCode" => "Currency iso code",
    "get2HTTPResponse" => "Get2 http response",
    "HTTPResponseCode" => "Http response code",
    "HTTPResponseCodeXY" => "Http response code xy",
    "supports IPv6 on iOS?" =>  "Supports ipv6 on ios",
  }.each do |actual, expected|
    it "applies sentencecase to #{actual.inspect} -> #{expected.inspect}" do
      expect(Strings::Case.sentencecase(actual)).to eq(expected)
    end
  end

  it "supports unicode", if: modern_ruby? do
    expect(Strings::Case.sentencecase("ЗдравствуйтеПривет")).to eq("Здравствуйте привет")
  end

  it "allows to preserve acronyms" do
    sentence = Strings::Case.sentencecase("HTTP response code", acronyms: ["HTTP"])

    expect(sentence).to eq("HTTP response code")
  end

  it "changes a separator to :" do
    sentence = Strings::Case.sentencecase("HTTP response code", separator: ":")

    expect(sentence).to eq("Http:response:code")
  end
end
