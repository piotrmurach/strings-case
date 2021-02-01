# frozen_string_literal: true

RSpec.describe Strings::Case, "#sentencecase" do
  {
    nil => nil,
    "" => "",
    "f" => "F",
    "1234" => "1234",
    "FOO" => "Foo",
    "FooBar" => "Foo bar",
    "fooBar" => "Foo bar",
    "foo bar" => "Foo bar",
    "Foo - Bar" => "Foo bar",
    "foo & bar" => "Foo & bar",
    "FooFooBar" => "Foo foo bar",
    "Foo2Foo2Bar" => "Foo2 foo2 bar",
    "foo-bar-baz" => "Foo bar baz",
    "foo_bar_1_2" => "Foo bar 1 2",
    "_foo_bar_baz_" => "Foo bar baz",
    "--foo-bar--" => "Foo bar",
    "FOO_BAR_baz" => "Foo bar baz",
    "__FOO_BAR__" => "Foo bar",
    "Foo w1th apo's and punc]t" => "Foo w1th apo's and punc]t",
    "getHTTPResponse" => "Get http response",
    "currencyISOCode" => "Currency iso code",
    "get2HTTPResponse" => "Get2 http response",
    "HTTPResponseCode" => "Http response code",
    "HTTPResponseCodeXY" => "Http response code xy",
    "supports IPv6 on iOS?" => "Supports i pv6 on i os"
  }.each do |actual, expected|
    it "applies sentencecase to #{actual.inspect} -> #{expected.inspect}" do
      expect(Strings::Case.sentencecase(actual)).to eq(expected)
    end
  end

  it "supports unicode", if: modern_ruby? do
    expect(Strings::Case.sentencecase("ЗдравствуйтеПривет")).to eq("Здравствуйте привет")
  end

  it "changes a separator to :" do
    sentence = Strings::Case.sentencecase("HTTP response code", separator: ":")

    expect(sentence).to eq("Http:response:code")
  end

  it "configures acronyms on a class method" do
    sentence = Strings::Case.sentencecase("HTTP response code", acronyms: ["HTTP"])

    expect(sentence).to eq("HTTP response code")
  end

  it "configures acronyms on an instance method" do
    strings = Strings::Case.new
    sentence = strings.sentencecase("HTTP response code", acronyms: %w[HTTP])

    expect(sentence).to eq("HTTP response code")
  end

  context "configures acronyms on an instance" do
    let(:acronyms) { %w[HTTP XML PostgreSQL SQL DOM XPath] }
    let(:strings) {
      Strings::Case.new.tap do |strings|
        strings.configure do |config|
          config.acronym(*acronyms)
        end
      end
    }

    {
      "http response code" => "HTTP response code",
      "https response code" => "Https response code",
      "xml_http_request" => "XML HTTP request",
      "XML_HTTP_Request" => "XML HTTP request",
      "xmlHTTPRequest" => "XML HTTP request",
      "XMLHTTPRequest" => "XML HTTP request",
      "xmlhttpRequest" => "Xmlhttp request",
      "postgresql_adapter" => "PostgreSQL adapter",
      "postgre_sql_adapter" => "Postgre SQL adapter",
      "xpath node" => "XPath node",
      "xpathnode" => "Xpathnode",
      "dom xpath element" => "DOM XPath element",
      "domxpath element" => "Domxpath element"
    }.each do |actual, expected|
      it "applies sentencecase to #{actual.inspect} -> #{expected.inspect}" do
        expect(strings.sentencecase(actual)).to eq(expected)
      end
    end
  end

  it "overrides global acronyms configuration" do
    strings = Strings::Case.new
    strings.configure do |config|
      config.acronym "HTTP"
    end

    sentence = strings.sentencecase("HTTP response code", acronyms: %w[XML])
    expect(sentence).to eq("Http response code")
  end
end
