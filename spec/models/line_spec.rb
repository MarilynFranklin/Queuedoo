require 'spec_helper'

describe Line do

  describe "validations" do
    it { should validate_presence_of :title }
  end

  describe "associations" do
    it { should belong_to :user }
  end

  describe "#first_queuer" do
    before do
      @line = Fabricate :line
      @first_queuer = Fabricate(:queuer, line: @line, name: "John", phone: "444-444-4444")
      @line.reload
      @second_queuer = Fabricate(:queuer, line: @line, name: "Mary", phone: "+15555555555")
    end

    context "line has queuers" do
      it "should be first_queuer" do
        @line.first_queuer.should == @first_queuer
      end
    end

    context "line doesn't have queuers" do
      it "should be nil" do
        line = Fabricate :line
        line.first_queuer.should == nil
      end
    end

  end

  describe "#move_up_queuers_behind(queuer)" do
    before do
      @line = Fabricate :line
      @first_queuer = Fabricate(:queuer, line: @line, name: "John", phone: "444-444-4444")
      @line.reload
      @second_queuer = Fabricate(:queuer, line: @line, name: "Mary", phone: "555-555-5555")
      @third_queuer = Fabricate(:queuer, line: @line, name: "Marvin", phone: "333-333-3333")
    end
    context "move up queuers after the first queuer" do
      it "should be 1" do
        @line.move_up_queuers_behind(@first_queuer)
        @second_queuer.reload.place_in_line.should == 1
        @third_queuer.reload.place_in_line.should == 2
      end
    end
    context "move up queuers in the middle of the line" do
      it "should be 1" do
        @line.move_up_queuers_behind(@second_queuer)
        @first_queuer.reload.place_in_line.should == 1
        @third_queuer.reload.place_in_line.should == 2
      end
    end

    context "try to move up queuers after the last queuer" do
      it "shouldn't make any changes" do
        @line.move_up_queuers_behind(@second_queuer)
        @first_queuer.reload.place_in_line.should == 1
        @third_queuer.place_in_line.should == 3
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

  describe "#toggle_text_to_join" do
    it "should be true" do
      line = Fabricate :line
      line.toggle_text_to_join
      line.text_to_join.should == true
    end
    it "should be false" do
      line = Fabricate :line
      line.text_to_join = true
      line.toggle_text_to_join
      line.text_to_join.should == false
    end
  end

end
