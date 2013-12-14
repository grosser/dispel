require "spec_helper"

describe Dispel do
  it "has a VERSION" do
    Dispel::VERSION.should =~ /^[\.\da-z]+$/
  end
end
