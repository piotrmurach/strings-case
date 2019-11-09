# frozen_string_literal: true

RSpec.describe Strings::Case, "#snakecase" do
  {
    nil => nil,
    "" => "",
    "f" => "f",
    "1234" => "1234",
    "FOO" => "foo",
    "FooBar" => "foo_bar",
    "fooBar" => "foo_bar",
    "foo bar" => "foo_bar",
    "Foo - Bar" => "foo_bar",
    "foo & bar" => "foo_bar",
    "FooFooBar" => "foo_foo_bar",
    "Foo2Foo2Bar" => "foo2_foo2_bar",
    "foo-bar-baz" => "foo_bar_baz",
    "foo_bar_1_2" => "foo_bar_1_2",
    "_foo_bar_baz_" => "_foo_bar_baz_",
    "--foo-bar--" => "foo_bar",
    "FOO_BAR_baz" => "foo_bar_baz",
    "__FOO_BAR__" => "_foo_bar_",
    "Foo w1th apo's and punc]t" => "foo_w1th_apos_and_punct",
    "getHTTPResponse" => "get_http_response",
    "currencyISOCode" => "currency_iso_code",
    "get2HTTPResponse" => "get2_http_response",
    "HTTPResponseCode" => "http_response_code",
    "HTTPResponseCodeXY" => "http_response_code_xy",
    "supports IPv6 on iOS?" =>  "supports_ipv6_on_ios",
  }.each do |actual, expected|
    it "applies snakecase to #{actual.inspect} -> #{expected.inspect}" do
      expect(Strings::Case.snakecase(actual)).to eq(expected)
    end
  end

  it "supports unicode", if: modern_ruby? do
    expect(Strings::Case.snakecase("ЗдравствуйтеПривет")).to eq("здравствуйте_привет")
  end

  it "allows to preserve acronyms" do
    snaked = Strings::Case.snakecase("HTTP response code", acronyms: ["HTTP"])

    expect(snaked).to eq("HTTP_response_code")
  end
end
