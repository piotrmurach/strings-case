# frozen_string_literal: true

require "strings/case/extensions"

using Strings::Case::Extensions

RSpec.describe Strings::Case::Extensions do
  it "camelcase a string" do
    expect("foo bar baz".camelcase).to eq("fooBarBaz")
  end

  it "camelcase a string with acronyms" do
    expect("HTTP Response Code".lower_camelcase(acronyms: ["HTTP"]))
      .to eq("HTTPResponseCode")
  end

  it "constcase a string" do
    expect("foo bar baz".constcase).to eq("FOO_BAR_BAZ")
  end

  it "headercases a string" do
    expect("foo bar baz".headercase).to eq("Foo-Bar-Baz")
  end

  it "headercases a string with acronyms" do
    expect("HTTP Response Code".headercase(acronyms: ["HTTP"]))
      .to eq("HTTP-Response-Code")
  end

  it "kebabcases a string" do
    expect("foo bar baz".kebabcase).to eq("foo-bar-baz")
  end

  it "kebabcases a string with acronyms" do
    expect("DOMXPathElement".dashcase(acronyms: %w[DOM XPath]))
      .to eq("dom-xpath-element")
  end

  it "pascalcases a string" do
    expect("foo bar baz".pascalcase).to eq("FooBarBaz")
  end

  it "pascalcases a string with acronyms" do
    expect("HTTP Response Code".pascalcase(acronyms: ["HTTP"]))
      .to eq("HTTPResponseCode")
  end

  it "pathcases a string" do
    expect("foo bar baz".pathcase).to eq("foo/bar/baz")
  end

  it "pathcases a string with acronyms" do
    expect("DOMXPathElement".pathcase(acronyms: %w[DOM XPath]))
      .to eq("dom/xpath/element")
  end

  it "sentencecases a string" do
    expect("foo bar baz".sentencecase).to eq("Foo bar baz")
  end

  it "sentencecases a string with acronyms" do
    expect("HTTP Response Code".sentencecase(acronyms: ["HTTP"]))
      .to eq("HTTP response code")
  end

  it "snakecases a string" do
    expect("foo bar baz".snakecase).to eq("foo_bar_baz")
  end

  it "snakecases a string with acronyms" do
    expect("DOMXPathElement".underscore(acronyms: %w[DOM XPath]))
      .to eq("dom_xpath_element")
  end

  it "titlecases a string" do
    expect("foo bar baz".titlecase).to eq("Foo Bar Baz")
  end

  it "titlecase a string with acronyms" do
    expect("HTTP Response Code".titlecase(acronyms: ["HTTP"]))
      .to eq("HTTP Response Code")
  end
end
