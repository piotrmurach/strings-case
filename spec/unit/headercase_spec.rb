# frozen_string_literal: true

RSpec.describe Strings::Case, "#headercase" do
  {
    nil => nil,
    "" => "",
    "1234" => "1234",
    "FOO" => "Foo",
    "FooBar" => "Foo-Bar",
    "fooBar" => "Foo-Bar",
    "foo bar" => "Foo-Bar",
    "Foo - Bar" => "Foo-Bar",
    "foo & bar" => "Foo-&-Bar",
    "FooFooBar" => "Foo-Foo-Bar",
    "Foo2Foo2Bar" => "Foo2-Foo2-Bar",
    "foo-bar-baz" => "Foo-Bar-Baz",
    "foo_bar_1_2" => "Foo-Bar-1-2",
    "_foo_bar_baz_" => "Foo-Bar-Baz",
    "--foo-bar--" => "-Foo-Bar-",
    "FOO_BAR_baz" => "Foo-Bar-Baz",
    "__FOO_BAR__" => "Foo-Bar",
    "Foo w1th apo's and punc]t" => "Foo-W1th-Apo's-And-Punc]t",
    "getHTTPResponse" => "Get-Http-Response",
    "currencyISOCode" => "Currency-Iso-Code",
    "get2HTTPResponse" => "Get2-Http-Response",
    "HTTPResponseCode" => "Http-Response-Code",
    "HTTPResponseCodeXY" => "Http-Response-Code-Xy",
    "supports IPv6 on iOS?" => "Supports-I-Pv6-On-I-Os"
  }.each do |actual, expected|
    it "applies headercase to #{actual.inspect} -> #{expected.inspect}" do
      expect(Strings::Case.headercase(actual)).to eq(expected)
    end
  end

  it "supports unicode", if: modern_ruby? do
    expect(Strings::Case.headercase("ЗдравствуйтеПривет")).to eq("Здравствуйте-Привет")
  end

  it "changes a separator to :" do
    headered = Strings::Case.headercase("HTTP response code", separator: ":")

    expect(headered).to eq("Http:Response:Code")
  end

  it "configures acronyms on a class method" do
    headered = Strings::Case.headercase("HTTP response code", acronyms: ["HTTP"])

    expect(headered).to eq("HTTP-Response-Code")
  end

  it "configures acronyms on an instance method" do
    strings = Strings::Case.new
    headered = strings.headercase("HTTP response code", acronyms: %w[HTTP])

    expect(headered).to eq("HTTP-Response-Code")
  end

  context "configures acronyms on an instance" do
    let(:acronyms) { %w[HTTP XML PostgreSQL SQL DOM XPath RESTful] }
    let(:strings) {
      Strings::Case.new.tap do |strings|
        strings.configure do |config|
          config.acronym(*acronyms)
        end
      end
    }

    {
      "http response code" => "HTTP-Response-Code",
      "https response code" => "Https-Response-Code",
      "xml_http_request" => "XML-HTTP-Request",
      "XML_HTTP_Request" => "XML-HTTP-Request",
      "xmlHTTPRequest" => "XML-HTTP-Request",
      "XMLHTTPRequest" => "XML-HTTP-Request",
      "xmlhttpRequest" => "Xmlhttp-Request",
      "postgresql_adapter" => "PostgreSQL-Adapter",
      "postgre_sql_adapter" => "Postgre-SQL-Adapter",
      "xpath node" => "XPath-Node",
      "xpathnode" => "Xpathnode",
      "dom xpath element" => "DOM-XPath-Element",
      "domxpath element" => "Domxpath-Element"
    }.each do |actual, expected|
      it "applies headercase to #{actual.inspect} -> #{expected.inspect}" do
        expect(strings.headercase(actual)).to eq(expected)
      end
    end
  end

  it "overrides global configuration on an instance method" do
    strings = Strings::Case.new
    strings.configure do |config|
      config.acronym "HTTP"
    end

    headered = strings.headercase("HTTP response code", acronyms: %w[XML])
    expect(headered).to eq("Http-Response-Code")
  end
end
