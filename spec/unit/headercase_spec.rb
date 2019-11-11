# frozen_string_literal: true

RSpec.describe Strings::Case, "#headercase" do
  {
    nil => nil,
    "" => "",
    "1234" => "1234",
    "FOO" => "Foo",
    "FooBar" => "Foo-Bar",
    "fooBar" => "Foo-Bar",
    "foo bar" => "Foo-Bar",
    "Foo - Bar" => "Foo-Bar",
    "foo & bar" => "Foo-Bar",
    "FooFooBar" => "Foo-Foo-Bar",
    "Foo2Foo2Bar" => "Foo2-Foo2-Bar",
    "foo-bar-baz" => "Foo-Bar-Baz",
    "foo_bar_1_2" => "Foo-Bar-1-2",
    "_foo_bar_baz_" => "Foo-Bar-Baz",
    "--foo-bar--" => "-Foo-Bar-",
    "FOO_BAR_baz" => "Foo-Bar-Baz",
    "__FOO_BAR__" => "Foo-Bar",
    "Foo w1th apo's and punc]t" => "Foo-W1th-Apos-And-Punct",
    "getHTTPResponse" => "Get-Http-Response",
    "currencyISOCode" => "Currency-Iso-Code",
    "get2HTTPResponse" => "Get2-Http-Response",
    "HTTPResponseCode" => "Http-Response-Code",
    "HTTPResponseCodeXY" => "Http-Response-Code-Xy",
    "supports IPv6 on iOS?" =>  "Supports-Ipv6-On-Ios",
  }.each do |actual, expected|
    it "applies headercase to #{actual.inspect} -> #{expected.inspect}" do
      expect(Strings::Case.headercase(actual)).to eq(expected)
    end
  end

  it "supports unicode", if: modern_ruby? do
    expect(Strings::Case.headercase("ЗдравствуйтеПривет")).to eq("Здравствуйте-Привет")
  end

  it "allows to preserve acronyms" do
    headered = Strings::Case.headercase("HTTP response code", acronyms: ["HTTP"])

    expect(headered).to eq("HTTP-Response-Code")
  end

  it "changes a separator to :" do
    headered = Strings::Case.headercase("HTTP response code", separator: ":")

    expect(headered).to eq("Http:Response:Code")
  end
end
