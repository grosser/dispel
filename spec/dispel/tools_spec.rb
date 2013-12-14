require "spec_helper"

describe Dispel::Tools do
  describe ".naive_split" do
    def call(*args)
      Dispel::Tools.naive_split(*args)
    end

    it "splits repeated pattern" do
      call("aaa", 'a').should == ['','','','']
    end

    it "splits normal stuff" do
      call("abacad", 'a').should == ['','b','c','d']
    end

    it "splits empty into 1" do
      call("", 'a').should == ['']
    end

    it "splits 1 into 2" do
      call("a", 'a').should == ['','']
    end
  end

  describe ".last_element" do
    def call(*args)
      Dispel::Tools.last_element(*args)
    end

    it "is the last for normal ranges" do
      call(1..2).should == 2
    end

    it "is the last for exclusive ranges" do
      call(1...3).should == 2
    end
  end
end
