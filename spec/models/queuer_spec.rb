require 'spec_helper'

describe Queuer do
  describe "validations" do
    it { should validate_presence_of :name }
  end
  describe "associations" do
    it { should belong_to :line }
  end
  describe "#skip" do
    it "should be 1" do
      line = Fabricate :line
      first_queuer = Fabricate(:queuer, line: line, name: "John")
      line.reload
      second_queuer = Fabricate(:queuer, line: line, name: "Mary")
      line.reload
      third_queuer = Fabricate(:queuer, line: line, name: "Marvin")
      line.reload
      first_queuer.skip!
      second_queuer.reload.place_in_line.should == 1
      first_queuer.reload.place_in_line.should == 2
    end
  end
end
