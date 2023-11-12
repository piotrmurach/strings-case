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
    "foo & bar" => "foo&Bar",
    "FooFooBar" => "fooFooBar",
    "Foo2Foo2Bar" => "foo2Foo2Bar",
    "foo-bar-baz" => "fooBarBaz",
    "foo_bar_1_2" => "fooBar12",
    "_foo_bar_baz_" => "fooBarBaz",
    "--foo-bar--" => "fooBar",
    "FOO_BAR_baz" => "fooBarBaz",
    "__FOO_BAR__" => "fooBar",
    "Foo w1th apo's and punc]t" => "fooW1thApo'sAndPunc]t",
    "getHTTPResponse" => "getHttpResponse",
    "currencyISOCode" => "currencyIsoCode",
    "get2HTTPResponse" => "get2HttpResponse",
    "HTTPResponseCode" => "httpResponseCode",
    "HTTPResponseCodeXY" => "httpResponseCodeXy",
    "supports IPv6 on iOS?" => "supportsIPv6OnIOs"
  }.each do |actual, expected|
    it "applies camelcase to #{actual.inspect} -> #{expected.inspect}" do
      expect(described_class.camelcase(actual)).to eq(expected)
    end
  end

  it "supports unicode", if: modern_ruby? do
    camelized = described_class.camelcase("ЗдравствуйтеПривет")

    expect(camelized).to eq("здравствуйтеПривет")
  end

  it "changes a separator to :" do
    camelized = described_class.camelcase("HTTP response code", separator: ":")

    expect(camelized).to eq("http:Response:Code")
  end

  it "configures acronyms on a class method" do
    camelized = described_class.lower_camelcase("HTTP response code",
                                                acronyms: ["HTTP"])

    expect(camelized).to eq("HTTPResponseCode")
  end

  it "configures acronyms on an instance method" do
    strings = described_class.new
    camelized = strings.camelcase("HTTP response code", acronyms: %w[HTTP])

    expect(camelized).to eq("HTTPResponseCode")
  end

  context "with acronyms configured on an instance" do
    let(:acronyms) { %w[HTTP XML PostgreSQL SQL DOM XPath] }
    let(:strings) {
      described_class.new.tap do |strings|
        strings.configure do |config|
          config.acronym(*acronyms)
        end
      end
    }

    {
      "http response code" => "HTTPResponseCode",
      "https response code" => "httpsResponseCode",
      "xml_http_request" => "XMLHTTPRequest",
      "XML_HTTP_Request" => "XMLHTTPRequest",
      "XMLHTTPRequest" => "XMLHTTPRequest",
      "xmlHTTPRequest" => "XMLHTTPRequest",
      "xmlhttpRequest" => "xmlhttpRequest",
      "postgresql_adapter" => "PostgreSQLAdapter",
      "postgre_sql_adapter" => "postgreSQLAdapter",
      "xpath node" => "XPathNode",
      "xpathnode" => "xpathnode",
      "dom xpath element" => "DOMXPathElement",
      "domxpath element" => "domxpathElement",
      "a dom element" => "aDOMElement"
    }.each do |actual, expected|
      it "applies camelcase to #{actual.inspect} -> #{expected.inspect}" do
        expect(strings.camelcase(actual)).to eq(expected)
      end
    end
  end

  it "overrides global acronyms in a method call" do
    strings = described_class.new
    strings.configure do |config|
      config.acronym "HTTP"
    end
    camelized = strings.camelcase("HTTP response code", acronyms: %w[XML])

    expect(camelized).to eq("httpResponseCode")
  end

  it "overrides global acronyms with an empty array in a method call" do
    strings = described_class.new(acronyms: %w[HTTP])
    camelized = strings.camelcase("HTTP response code", acronyms: [])

    expect(camelized).to eq("httpResponseCode")
  end
end
