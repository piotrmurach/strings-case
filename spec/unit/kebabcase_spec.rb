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
    "foo & bar" => "foo-&-bar",
    "FooFooBar" => "foo-foo-bar",
    "Foo2Foo2Bar" => "foo2-foo2-bar",
    "foo-bar-baz" => "foo-bar-baz",
    "_foo_bar_baz_" => "foo-bar-baz",
    "--foo-bar--" => "-foo-bar-",
    "FOO_BAR_baz" => "foo-bar-baz",
    "__FOO_BAR__" => "foo-bar",
    "Foo w1th apo's and punc]t" => "foo-w1th-apo's-and-punc]t",
    "getHTTPResponse" => "get-http-response",
    "currencyISOCode" => "currency-iso-code",
    "get2HTTPResponse" => "get2-http-response",
    "HTTPResponseCode" => "http-response-code",
    "HTTPResponseCodeXY" => "http-response-code-xy",
    "supports IPv6 on iOS?" => "supports-i-pv6-on-i-os"
  }.each do |actual, expected|
    it "applies kebabcase from #{actual.inspect} to #{expected.inspect}" do
      expect(Strings::Case.kebabcase(actual)).to eq(expected)
    end
  end

  it "supports unicode", if: modern_ruby? do
    expect(Strings::Case.kebabcase("ЗдравствуйтеПривет")).to eq("здравствуйте-привет")
  end

  it "changes a separator to :" do
    dashed = Strings::Case.kebabcase("HTTP response code", separator: ":")

    expect(dashed).to eq("http:response:code")
  end

  it "configures acronyms on a class method" do
    dashed = Strings::Case.dashcase("DOMXPathElement", acronyms: %w[DOM XPath])

    expect(dashed).to eq("dom-xpath-element")
  end

  it "configures acronyms on an instance method" do
    strings = Strings::Case.new
    dashed = strings.kebabcase("DOMXPathElement", acronyms: %w[DOM XPath])

    expect(dashed).to eq("dom-xpath-element")
  end

  context "configures acronyms on an instance" do
    let(:acronyms) { %w[HTTP XML PostgreSQL SQL XPath DOM] }
    let(:strings) {
      Strings::Case.new.tap do |strings|
        strings.configure do |config|
          config.acronym(*acronyms)
        end
      end
    }

    {
      "HTTPResponseCode" => "http-response-code",
      "httpsResponseCode" => "https-response-code",
      "XMLHTTPRequest" => "xml-http-request",
      "xmlHTTPRequest" => "xml-http-request",
      "xmlhttpRequest" => "xmlhttp-request",
      "PostgreSQLAdapter" => "postgresql-adapter",
      "postgreSQLAdapter" => "postgre-sql-adapter",
      "XPathNode" => "xpath-node",
      "xpathnode" => "xpathnode",
      "DOMXPathElement" => "dom-xpath-element",
      "domxpathElement" => "domxpath-element",
      "ADOMElement" => "a-dom-element"
    }.each do |actual, expected|
      it "applies kebabcase to #{actual.inspect} -> #{expected.inspect}" do
        expect(strings.kebabcase(actual)).to eq(expected)
      end
    end
  end

  it "overrides global acronyms in a method call" do
    strings = described_class.new
    strings.configure do |config|
      config.acronym "DOM"
      config.acronym "XPath"
    end
    dashed = strings.kebabcase("DOMXPathElement", acronyms: %w[XML])

    expect(dashed).to eq("domx-path-element")
  end

  it "overrides global acronyms with an empty array in a method call" do
    strings = described_class.new(acronyms: %w[DOM XPath])
    dashed = strings.kebabcase("DOMXPathElement", acronyms: [])

    expect(dashed).to eq("domx-path-element")
  end
end
