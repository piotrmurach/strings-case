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
    "foo & bar" => "Foo&Bar",
    "FooFooBar" => "FooFooBar",
    "Foo2Foo2Bar" => "Foo2Foo2Bar",
    "foo-bar-baz" => "FooBarBaz",
    "foo_bar_1_2" => "FooBar12",
    "_foo_bar_baz_" => "FooBarBaz",
    "--foo-bar--" => "FooBar",
    "FOO_BAR_baz" => "FooBarBaz",
    "__FOO_BAR__" => "FooBar",
    "Foo w1th apo's and punc]t" => "FooW1thApo'sAndPunc]t",
    "getHTTPResponse" => "GetHttpResponse",
    "currencyISOCode" => "CurrencyIsoCode",
    "get2HTTPResponse" => "Get2HttpResponse",
    "HTTPResponseCode" => "HttpResponseCode",
    "HTTPResponseCodeXY" => "HttpResponseCodeXy",
    "supports IPv6 on iOS?" => "SupportsIPv6OnIOs"
  }.each do |actual, expected|
    it "applies pascalcase to #{actual.inspect} -> #{expected.inspect}" do
      expect(described_class.pascalcase(actual)).to eq(expected)
    end
  end

  it "supports unicode", if: modern_ruby? do
    pascalized = described_class.pascalcase("ЗдравствуйтеПривет")

    expect(pascalized).to eq("ЗдравствуйтеПривет")
  end

  it "changes a separator to :" do
    pascalized = described_class.pascalcase("HTTP response code",
                                            separator: ":")

    expect(pascalized).to eq("Http:Response:Code")
  end

  it "configures acronyms on a class method" do
    pascalized = described_class.upper_camelcase("HTTP response code",
                                                 acronyms: ["HTTP"])

    expect(pascalized).to eq("HTTPResponseCode")
  end

  it "configures acronyms on an instance method" do
    strings = described_class.new
    pascalized = strings.pascalcase("HTTP response code", acronyms: %w[HTTP])

    expect(pascalized).to eq("HTTPResponseCode")
  end

  context "with acronyms configured on an instance" do
    let(:acronyms) { %w[HTTP XML PostgreSQL SQL DOM XPath RESTful] }
    let(:strings) {
      described_class.new.tap do |strings|
        strings.configure do |config|
          config.acronym(*acronyms)
        end
      end
    }

    {
      "http response code" => "HTTPResponseCode",
      "https response code" => "HttpsResponseCode",
      "xml_http_request" => "XMLHTTPRequest",
      "XML_HTTP_Request" => "XMLHTTPRequest",
      "xmlHTTPRequest" => "XMLHTTPRequest",
      "XMLHTTPRequest" => "XMLHTTPRequest",
      "xmlhttpRequest" => "XmlhttpRequest",
      "postgresql_adapter" => "PostgreSQLAdapter",
      "postgre_sql_adapter" => "PostgreSQLAdapter",
      "xpath node" => "XPathNode",
      "xpathnode" => "Xpathnode",
      "dom xpath element" => "DOMXPathElement",
      "domxpath element" => "DomxpathElement",
      "a dom element" => "ADOMElement"
    }.each do |actual, expected|
      it "applies pascalcase to #{actual.inspect} -> #{expected.inspect}" do
        expect(strings.pascalcase(actual)).to eq(expected)
      end
    end
  end

  it "overrides global acronyms in a method call" do
    strings = described_class.new
    strings.configure do |config|
      config.acronym "HTTP"
    end
    pascalized = strings.pascalcase("HTTP response code", acronyms: %w[XML])

    expect(pascalized).to eq("HttpResponseCode")
  end

  it "overrides global acronyms with an empty array in a method call" do
    strings = described_class.new(acronyms: %w[HTTP])
    pascalized = strings.pascalcase("HTTP response code", acronyms: [])

    expect(pascalized).to eq("HttpResponseCode")
  end
end
