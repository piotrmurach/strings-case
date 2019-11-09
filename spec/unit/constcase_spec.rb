# frozen_string_literal: true

RSpec.describe Strings::Case, "#constcase" do
  {
    nil => nil,
    "" => "",
    "1234" => "1234",
    "FOO" => "FOO",
    "FooBar" => "FOO_BAR",
    "fooBar" => "FOO_BAR",
    "foo bar" => "FOO_BAR",
    "Foo - Bar" => "FOO_BAR",
    "foo & bar" => "FOO_BAR",
    "FooFooBar" => "FOO_FOO_BAR",
    "Foo2Foo2Bar" => "FOO2_FOO2_BAR",
    "foo-bar-baz" => "FOO_BAR_BAZ",
    "foo_bar_1_2" => "FOO_BAR_1_2",
    "_foo_bar_baz_" => "_FOO_BAR_BAZ_",
    "--foo-bar--" => "FOO_BAR",
    "FOO_BAR_baz" => "FOO_BAR_BAZ",
    "__FOO_BAR__" => "_FOO_BAR_",
    "Foo w1th apo's and punc]t" => "FOO_W1TH_APOS_AND_PUNCT",
    "getHTTPResponse" => "GET_HTTP_RESPONSE",
    "currencyISOCode" => "CURRENCY_ISO_CODE",
    "get2HTTPResponse" => "GET2_HTTP_RESPONSE",
    "HTTPResponseCode" => "HTTP_RESPONSE_CODE",
    "HTTPResponseCodeXY" => "HTTP_RESPONSE_CODE_XY",
    "supports IPv6 on iOS?" =>  "SUPPORTS_IPV6_ON_IOS",
  }.each do |actual, expected|
    it "applies constcase to #{actual.inspect} -> #{expected.inspect}" do
      expect(Strings::Case.constcase(actual)).to eq(expected)
    end
  end

  it "supports unicode", if: modern_ruby? do
    expect(Strings::Case.constantcase("ЗдравствуйтеПривет")).to eq("ЗДРАВСТВУЙТЕ_ПРИВЕТ")
  end
end
