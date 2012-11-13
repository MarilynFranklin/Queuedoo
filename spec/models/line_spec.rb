require 'spec_helper'

describe Line do
  describe "validations" do
    it { should validate_presence_of :title }
  end
  describe "#next_spot" do
    it "should be 1" do
      line = Fabricate :line
      line.next_spot.should == 1
    end
  end
end
