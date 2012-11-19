require 'spec_helper'

describe Queuer do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :phone }
    # it { should validate_uniqueness_of :phone }
  end
  describe "associations" do
    it { should belong_to :line }
  end
  describe "#skip" do
    it "should be 1" do
      line = Fabricate :line
      first_queuer = Fabricate(:queuer, line: line, name: "John", phone: "444-444-4444")
      line.reload
      second_queuer = Fabricate(:queuer, line: line, name: "Mary", phone: "555-555-5555")
      line.reload
      third_queuer = Fabricate(:queuer, line: line, name: "Marvin", phone: "333-333-3333")
      line.reload
      first_queuer.skip!
      second_queuer.reload.place_in_line.should == 1
      first_queuer.reload.place_in_line.should == 2
    end
  end
end
