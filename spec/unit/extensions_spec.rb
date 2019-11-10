# frozen_string_literal: true

require "strings/case/extensions"

using Strings::Case::Extensions

RSpec.describe Strings::Case::Extensions do
  it "camelcase a string" do
    expect("foo bar baz".camelcase).to eq("fooBarBaz")
  end

  it "camelcase a string with acronyms" do
    expect("HTTP Response Case".lower_camelcase(acronyms: ["HTTP"])).to eq("HTTPResponseCase")
  end

  it "constcase a string" do
    expect("foo bar baz".constcase).to eq("FOO_BAR_BAZ")
  end

  it "headercases a string" do
    expect("foo bar baz".headercase).to eq("Foo-Bar-Baz")
  end

  it "headercases a string with acronyms" do
    expect("HTTP Response Case".headercase(acronyms: ["HTTP"])).to eq("HTTP-Response-Case")
  end

  it "kebabcases a string" do
    expect("foo bar baz".kebabcase).to eq("foo-bar-baz")
  end

  it "kebabcases a string with acronyms" do
    expect("HTTP Response Case".dashcase(acronyms: ["HTTP"])).to eq("HTTP-response-case")
  end

  it "pascalcases a string" do
    expect("foo bar baz".pascalcase).to eq("FooBarBaz")
  end

  it "pascalcases a string with acronyms" do
    expect("HTTP Response Case".pascalcase(acronyms: ["HTTP"])).to eq("HTTPResponseCase")
  end

  it "pathcases a string" do
    expect("foo bar baz".pathcase).to eq("foo/bar/baz")
  end

  it "pathcases a string with acronyms" do
    expect("HTTP Response Case".pathcase(acronyms: ["HTTP"])).to eq("HTTP/response/case")
  end

  it "sentencecases a string" do
    expect("foo bar baz".sentencecase).to eq("Foo bar baz")
  end

  it "sentencecases a string with acronyms" do
    expect("HTTP Response Case".sentencecase(acronyms: ["HTTP"])).to eq("HTTP response case")
  end

  it "snakecases a string" do
    expect("foo bar baz".snakecase).to eq("foo_bar_baz")
  end

  it "snakecases a string with acronyms" do
    expect("HTTP Response Case".underscore(acronyms: ["HTTP"])).to eq("HTTP_response_case")
  end

  it "titlecases a string" do
    expect("foo bar baz".titlecase).to eq("Foo Bar Baz")
  end

  it "titlecase a string with acronyms" do
    expect("HTTP Response Case".titlecase(acronyms: ["HTTP"])).to eq("HTTP Response Case")
  end
end
