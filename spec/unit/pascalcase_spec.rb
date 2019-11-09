# frozen_string_literal: true

RSpec.describe Strings::Case, "#pascalcase" do
  {
    nil => nil,
    "" => "",
    "f" => "F",
    "1234" => "1234",
    "FOO" => "Foo",
    "FooBar" => "FooBar",
    "fooBar" => "FooBar",
    "foo bar" => "FooBar",
    "Foo - Bar" => "FooBar",
    "foo & bar" => "FooBar",
    "FooFooBar" => "FooFooBar",
    "Foo2Foo2Bar" => "Foo2Foo2Bar",
    "foo-bar-baz" => "FooBarBaz",
    "foo_bar_1_2" => "FooBar12",
    "_foo_bar_baz_" => "FooBarBaz",
    "--foo-bar--" => "FooBar",
    "FOO_BAR_baz" => "FooBarBaz",
    "__FOO_BAR__" => "FooBar",
    "Foo w1th apo's and punc]t" => "FooW1thAposAndPunct",
    "ЗдравствуйтеПривет" => "ЗдравствуйтеПривет",
    "getHTTPResponse" => "GetHttpResponse",
    "currencyISOCode" => "CurrencyIsoCode",
    "get2HTTPResponse" => "Get2HttpResponse",
    "HTTPResponseCode" => "HttpResponseCode",
    "HTTPResponseCodeXY" => "HttpResponseCodeXy",
    "supports IPv6 on iOS?" =>  "SupportsIpv6OnIos"
  }.each do |actual, expected|
    it "applies pascalcase to #{actual.inspect} -> #{expected.inspect}" do
      expect(Strings::Case.pascalcase(actual)).to eq(expected)
    end
  end

  it "allows to preserve acronyms" do
    camelized = Strings::Case.upper_camelcase("HTTP response code", acronyms: ["HTTP"])

    expect(camelized).to eq("HTTPResponseCode")
  end
end
