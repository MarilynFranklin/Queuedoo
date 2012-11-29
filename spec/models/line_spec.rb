require 'spec_helper'

describe Line do

  describe "validations" do
    it { should validate_presence_of :title }
  end

  describe "associations" do
    it { should belong_to :user }
  end

  describe "#move_up_queuers_behind" do
    before do
      line = Fabricate :line
      @first_queuer = Fabricate(:queuer, line: line, name: "John", phone: "444-444-4444")
      line.reload
      @second_queuer = Fabricate(:queuer, line: line, name: "Mary", phone: "555-555-5555")
      @third_queuer = Fabricate(:queuer, line: line, name: "Marvin", phone: "333-333-3333")
    end
    context "first in line is processed" do
      it "should be 1" do
        @first_queuer.process!
        @second_queuer.reload.place_in_line.should == 1
        @third_queuer.reload.place_in_line.should == 2
      end
    end
    context "process queuer in the middle of the line" do
      it "should be 1" do
        @second_queuer.process!
        @second_queuer.reload.place_in_line.should == 0
        @first_queuer.reload.place_in_line.should == 1
        @third_queuer.reload.place_in_line.should == 2
      end
    end
  end

  describe "#next_spot" do
    it "should be 1" do
      line = Fabricate :line
      line.next_spot.should == 1
    end
  end

  describe "#number_of_queuers" do
    before do
      @line = Fabricate :line
    end
    it "should be 0" do
      @line.number_of_queuers.should == 0
    end
    it "should be 2" do
      first_queuer = Fabricate(:queuer, line: @line, name: "John", phone: "444-444-4444")
      @line.reload
      second_queuer = Fabricate(:queuer, line: @line, name: "Mary", phone: "555-555-5555")
      @line.number_of_queuers.should == 2
    end
  end

end
