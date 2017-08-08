require "spec_helper"

RSpec.describe S3sync do
  it "has a version number" do
    expect(S3sync::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
