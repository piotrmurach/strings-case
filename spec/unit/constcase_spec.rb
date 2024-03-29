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
    "foo & bar" => "FOO_&_BAR",
    "FooFooBar" => "FOO_FOO_BAR",
    "Foo2Foo2Bar" => "FOO2_FOO2_BAR",
    "foo-bar-baz" => "FOO_BAR_BAZ",
    "foo_bar_1_2" => "FOO_BAR_1_2",
    "_foo_bar_baz_" => "_FOO_BAR_BAZ_",
    "--foo-bar--" => "FOO_BAR",
    "FOO_BAR_baz" => "FOO_BAR_BAZ",
    "__FOO_BAR__" => "_FOO_BAR_",
    "Foo w1th apo's and punc]t" => "FOO_W1TH_APO'S_AND_PUNC]T",
    "getHTTPResponse" => "GET_HTTP_RESPONSE",
    "currencyISOCode" => "CURRENCY_ISO_CODE",
    "get2HTTPResponse" => "GET2_HTTP_RESPONSE",
    "HTTPResponseCode" => "HTTP_RESPONSE_CODE",
    "HTTPResponseCodeXY" => "HTTP_RESPONSE_CODE_XY",
    "supports IPv6 on iOS?" => "SUPPORTS_I_PV6_ON_I_OS"
  }.each do |actual, expected|
    it "applies constcase to #{actual.inspect} -> #{expected.inspect}" do
      expect(described_class.constcase(actual)).to eq(expected)
    end
  end

  it "supports unicode", if: modern_ruby? do
    constant = described_class.constantcase("ЗдравствуйтеПривет")

    expect(constant).to eq("ЗДРАВСТВУЙТЕ_ПРИВЕТ")
  end

  it "changes a separator to :" do
    constant = described_class.constcase("HTTP response code", separator: ":")

    expect(constant).to eq("HTTP:RESPONSE:CODE")
  end

  it "configures acronyms on a class method" do
    constant = described_class.constcase("DOMXPathElement",
                                         acronyms: %w[DOM XPath])

    expect(constant).to eq("DOM_XPATH_ELEMENT")
  end

  it "configures acronyms on an instance method" do
    strings = described_class.new
    constant = strings.constcase("DOMXPathElement", acronyms: %w[DOM XPath])

    expect(constant).to eq("DOM_XPATH_ELEMENT")
  end

  context "with acronyms configured on an instance" do
    let(:acronyms) { %w[HTTP XML PostgreSQL SQL XPath DOM] }
    let(:strings) {
      described_class.new.tap do |strings|
        strings.configure do |config|
          config.acronym(*acronyms)
        end
      end
    }

    {
      "HTTPResponseCode" => "HTTP_RESPONSE_CODE",
      "httpsResponseCode" => "HTTPS_RESPONSE_CODE",
      "XMLHTTPRequest" => "XML_HTTP_REQUEST",
      "xmlHTTPRequest" => "XML_HTTP_REQUEST",
      "xmlhttpRequest" => "XMLHTTP_REQUEST",
      "PostgreSQLAdapter" => "POSTGRESQL_ADAPTER",
      "postgreSQLAdapter" => "POSTGRE_SQL_ADAPTER",
      "XPathNode" => "XPATH_NODE",
      "xpathnode" => "XPATHNODE",
      "DOMXPathElement" => "DOM_XPATH_ELEMENT",
      "domxpathElement" => "DOMXPATH_ELEMENT",
      "ADOMElement" => "A_DOM_ELEMENT"
    }.each do |actual, expected|
      it "applies constcase to #{actual.inspect} -> #{expected.inspect}" do
        expect(strings.constcase(actual)).to eq(expected)
      end
    end
  end

  it "overrides global acronyms in a method call" do
    strings = described_class.new
    strings.configure do |config|
      config.acronym "DOM"
      config.acronym "XPath"
    end
    constant = strings.constcase("DOMXPathElement", acronyms: %w[XML])

    expect(constant).to eq("DOMX_PATH_ELEMENT")
  end

  it "overrides global acronyms with an empty array in a method call" do
    strings = described_class.new(acronyms: %w[DOM XPath])
    constant = strings.constcase("DOMXPathElement", acronyms: [])

    expect(constant).to eq("DOMX_PATH_ELEMENT")
  end
end
