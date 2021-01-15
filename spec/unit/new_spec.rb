# frozen_string_literal: true

RSpec.describe Strings::Case, ".new" do
  it "creates a global instance only once" do
    Strings::Case.instance_variable_set(:@__instance__, nil)
    expect(Strings::Case).to receive(:new).once.and_call_original
    Strings::Case.camelcase("test")
    Strings::Case.camelcase("test")
  end
end
