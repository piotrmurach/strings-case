# frozen_string_literal: true

RSpec.describe Strings::Case, "#pathcase" do
  {
    nil => nil,
    "" => "",
    "f" => "f",
    "1234" => "1234",
    "FOO" => "foo",
    "FooBar" => "foo/bar",
    "fooBar" => "foo/bar",
    "foo bar" => "foo/bar",
    "Foo - Bar" => "foo/bar",
    "foo & bar" => "foo/bar",
    "FooFooBar" => "foo/foo/bar",
    "Foo2Foo2Bar" => "foo2/foo2/bar",
    "foo-bar-baz" => "foo/bar/baz",
    "foo_bar_1_2" => "foo/bar/1/2",
    "_foo_bar_baz_" => "foo/bar/baz",
    "--foo-bar--" => "foo/bar",
    "FOO_BAR_baz" => "foo/bar/baz",
    "__FOO_BAR__" => "foo/bar",
    "Foo w1th apo's and punc]t" => "foo/w1th/apos/and/punct",
    "getHTTPResponse" => "get/http/response",
    "currencyISOCode" => "currency/iso/code",
    "get2HTTPResponse" => "get2/http/response",
    "HTTPResponseCode" => "http/response/code",
    "HTTPResponseCodeXY" => "http/response/code/xy",
    "supports IPv6 on iOS?" => "supports/ipv6/on/ios"
  }.each do |actual, expected|
    it "applies pathcase to #{actual.inspect} -> #{expected.inspect}" do
      expect(Strings::Case.pathcase(actual)).to eq(expected)
    end
  end

  it "supports unicode", if: modern_ruby? do
    expect(Strings::Case.pathcase("ЗдравствуйтеПривет")).to eq("здравствуйте/привет")
  end

  it "changes file path separator" do
    pathed = Strings::Case.pathcase("HTTP response code", separator: "\\")

    expect(pathed).to eq("http\\response\\code")
  end

  it "configures acronyms on a class method" do
    pathed = Strings::Case.pathcase("DOMXPathElement", acronyms: %w[DOM XPath])

    expect(pathed).to eq("dom/xpath/element")
  end

  it "configures acronyms on an instance method" do
    strings = Strings::Case.new
    pathed = strings.pathcase("DOMXPathElement", acronyms: %w[DOM XPath])

    expect(pathed).to eq("dom/xpath/element")
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
      "HTTPResponseCode" => "http/response/code",
      "httpsResponseCode" => "https/response/code",
      "XMLHTTPRequest" => "xml/http/request",
      "xmlHTTPRequest" => "xml/http/request",
      "xmlhttpRequest" => "xmlhttp/request",
      "PostgreSQLAdapter" => "postgresql/adapter",
      "postgreSQLAdapter" => "postgre/sql/adapter",
      "XPathNode" => "xpath/node",
      "xpathnode" => "xpathnode",
      "DOMXPathElement" => "dom/xpath/element",
      "domxpathElement" => "domxpath/element"
    }.each do |actual, expected|
      it "applies pathcase to #{actual.inspect} -> #{expected.inspect}" do
        expect(strings.pathcase(actual)).to eq(expected)
      end
    end
  end

  it "overrides global configuration on an instance method" do
    strings = Strings::Case.new
    strings.configure do |config|
      config.acronym "DOM"
      config.acronym "XPath"
    end

    pathed = strings.pathcase("DOMXPathElement", acronyms: %w[XML])
    expect(pathed).to eq("domx/path/element")
  end
end
