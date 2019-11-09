# frozen_string_literal: true

RSpec.describe Strings::Case, "#kebabcase" do
  {
    "" => "",
    "1234" => "1234",
    "FOO" => "foo",
    "FooBar" => "foo-bar",
    "fooBar" => "foo-bar",
    "foo bar" => "foo-bar",
    "Foo - Bar" => "foo-bar",
    "foo & bar" => "foo-bar",
    "FooFooBar" => "foo-foo-bar",
    "Foo2Foo2Bar" => "foo2-foo2-bar",
    "foo-bar-baz" => "foo-bar-baz",
    "_foo_bar_baz_" => "foo-bar-baz",
    "--foo-bar--" => "-foo-bar-",
    "FOO_BAR_baz" => "foo-bar-baz",
    "__FOO_BAR__" => "foo-bar",
    "Foo w1th apo's and punc]t" => "foo-w1th-apos-and-punct",
    "getHTTPResponse" => "get-http-response",
    "currencyISOCode" => "currency-iso-code",
    "get2HTTPResponse" => "get2-http-response",
    "HTTPResponseCode" => "http-response-code",
    "HTTPResponseCodeXY" => "http-response-code-xy",
    "supports IPv6 on iOS?" =>  "supports-ipv6-on-ios"
  }.each do |actual, expected|
    it "applies kebabcase from #{actual.inspect} to #{expected.inspect}" do
      expect(Strings::Case.kebabcase(actual)).to eq(expected)
    end
  end

  it "supports unicode", if: modern_ruby? do
    expect(Strings::Case.kebabcase("ЗдравствуйтеПривет")).to eq("здравствуйте-привет")
  end

  it "allows to preserve acronyms" do
    dashed = Strings::Case.dashcase("HTTP response code", acronyms: ["HTTP"])

    expect(dashed).to eq("HTTP-response-code")
  end
end
