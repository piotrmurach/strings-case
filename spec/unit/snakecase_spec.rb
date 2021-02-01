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
    "foo & bar" => "foo_&_bar",
    "FooFooBar" => "foo_foo_bar",
    "Foo2Foo2Bar" => "foo2_foo2_bar",
    "foo-bar-baz" => "foo_bar_baz",
    "foo_bar_1_2" => "foo_bar_1_2",
    "_foo_bar_baz_" => "_foo_bar_baz_",
    "--foo-bar--" => "foo_bar",
    "FOO_BAR_baz" => "foo_bar_baz",
    "__FOO_BAR__" => "_foo_bar_",
    "Foo w1th apo's and punc]t" => "foo_w1th_apo's_and_punc]t",
    "getHTTPResponse" => "get_http_response",
    "currencyISOCode" => "currency_iso_code",
    "get2HTTPResponse" => "get2_http_response",
    "HTTPResponseCode" => "http_response_code",
    "HTTPResponseCodeXY" => "http_response_code_xy",
    "supports IPv6 on iOS?" => "supports_i_pv6_on_i_os"
  }.each do |actual, expected|
    it "applies snakecase to #{actual.inspect} -> #{expected.inspect}" do
      expect(Strings::Case.snakecase(actual)).to eq(expected)
    end
  end

  it "supports unicode", if: modern_ruby? do
    expect(Strings::Case.snakecase("ЗдравствуйтеПривет")).to eq("здравствуйте_привет")
  end

  it "changes a separator to :" do
    snaked = Strings::Case.snakecase("HTTP response code", separator: ":")

    expect(snaked).to eq("http:response:code")
  end

  it "configures acronyms on a class method" do
    snaked = Strings::Case.underscore("DOMXPathElement", acronyms: %w[DOM XPath])

    expect(snaked).to eq("dom_xpath_element")
  end

  it "configures acronyms on an instance method" do
    strings = Strings::Case.new
    snaked = strings.snakecase("DOMXPathElement", acronyms: %w[DOM XPath])

    expect(snaked).to eq("dom_xpath_element")
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
      "HTTPResponseCode" => "http_response_code",
      "httpsResponseCode" => "https_response_code",
      "XMLHTTPRequest" => "xml_http_request",
      "xmlHTTPRequest" => "xml_http_request",
      "xmlhttpRequest" => "xmlhttp_request",
      "PostgreSQLAdapter" => "postgresql_adapter",
      "postgreSQLAdapter" => "postgre_sql_adapter",
      "XPathNode" => "xpath_node",
      "xpathnode" => "xpathnode",
      "DOMXPathElement" => "dom_xpath_element",
      "domxpathElement" => "domxpath_element"
    }.each do |actual, expected|
      it "applies snakecase to #{actual.inspect} -> #{expected.inspect}" do
        expect(strings.snakecase(actual)).to eq(expected)
      end
    end
  end

  it "overrides global configuration on an instance method" do
    strings = Strings::Case.new
    strings.configure do |config|
      config.acronym "DOM"
      config.acronym "XPath"
    end

    snaked = strings.snakecase("DOMXPathElement", acronyms: %w[XML])
    expect(snaked).to eq("domx_path_element")
  end
end
