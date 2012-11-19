require 'spec_helper'

describe Line do
  describe "validations" do
    it { should validate_presence_of :title }
  end
  describe "associations" do
    it { should belong_to :user }
  end
  describe "#next_spot" do
    it "should be 1" do
      line = Fabricate :line
      line.next_spot.should == 1
    end
  end
  describe "#move_up_queuers" do
    it "should be 1" do
      line = Fabricate :line
      first_queuer = Fabricate(:queuer, line: line, name: "John", phone: "444-444-4444")
      line.reload
      second_queuer = Fabricate(:queuer, line: line, name: "Mary", phone: "555-555-5555")
      line.reload
      third_queuer = Fabricate(:queuer, line: line, name: "Marvin", phone: "333-333-3333")
      line.reload

      first_queuer.process!

      second_queuer.reload.place_in_line.should == 1
      third_queuer.reload.place_in_line.should == 2
    end
  end
end
