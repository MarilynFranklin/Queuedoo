require 'spec_helper'

describe Queuer do
  include SmsSpec::Helpers

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :phone }
    it { should validate_format_of :phone }
  end

  describe "associations" do
    it { should belong_to :line }
    it { should belong_to :user }
  end

  describe "#add_to_line(line)" do

    it "should belong to line2" do
      line = Fabricate :line
      queuer = Fabricate(:queuer, line: line, name: "John", phone: "444-444-4444")
      line2 = Fabricate :line
      queuer.process!
      queuer.add_to_line(line2)
      queuer.processed.should == false
      queuer.place_in_line.should == 1
      queuer.line.should == line2
    end
  end

  context "formatting phone number" do

    before do
      @line = Fabricate :line
    end

    describe "#format_number(number)" do

      it "should contain international code and contain digits only" do
        queuer = Fabricate(:queuer, line: @line, name: "John", phone: "444-444-4444")
        queuer.format_number("444-444-4444").should == "+14444444444"
      end

      it "should not have exta +1" do
        queuer = Fabricate(:queuer, line: @line, name: "John", phone: "+1444-444-4444")
        queuer.format_number("+1444-444-4444").should == "+14444444444"
      end
    end

    describe "formatted_number" do
      it "should be set to contain international code and contain digits only" do
        queuer = Fabricate(:queuer, line: @line, name: "John", phone: "(555)-555-5555")
        queuer.formatted_number.should == "+15555555555"
      end
    end
  end

  describe "#next_queuers" do

    before do
      @line = Fabricate :line
      @first_queuer = Fabricate(:queuer, line: @line, name: "John", phone: "444-444-4444")
      @line.reload
      @second_queuer = Fabricate(:queuer, line: @line, name: "Mary", phone: "+15555555555")
      @line.reload
      @third_queuer = Fabricate(:queuer, line: @line, name: "Marvin", phone: "333-333-3333")
    end

    context "line has users" do
      it "should return 2 queuers" do
        @first_queuer.next_queuers.should == [@second_queuer, @third_queuer]
      end

      it "should return 1 queuer" do
        @second_queuer.next_queuers.should == [@third_queuer]
      end
    end

    context "two lines in database, and queuer is the only one in his line" do

      it "should be nil" do
        line = Fabricate :line
        queuer = Fabricate(:queuer, line: line, name: "Martin", phone: "999-999-9999")
        queuer.next_queuers.should == []
      end
    end

  end

  describe "#text(message)" do

    it "should text queuear with the given message" do
      line = Fabricate :line
      queuer = Fabricate(:queuer, line: line, name: "John", phone: "+14444444444")
      queuer.text("Hello there")
      open_last_text_message_for "+14444444444"
      current_text_message.should have_body "Hello there"
    end
  end

  describe "#last?" do

    before do
      line = Fabricate :line
      @first_queuer = Fabricate(:queuer, line: line, name: "John", phone: "444-444-4444")
      line.reload
      @second_queuer = Fabricate(:queuer, line: line, name: "Mary", phone: "+15555555555")
    end

    it "should be true" do
      @first_queuer.last?.should == false
    end

    it "should be false" do
      @second_queuer.last?.should == true
    end
  end

  describe "#process!" do

    context "first person in line is processed" do

      it "should be 0" do
       line = Fabricate :line
       first_queuer = Fabricate(:queuer, line: line, name: "John", phone: "444-444-4444")
       second_queuer = Fabricate(:queuer, line: line, name: "Mary", phone: "+15555555555")
       third_queuer = Fabricate(:queuer, line: line, name: "Marvin", phone: "333-333-3333")

       first_queuer.process!
       first_queuer.processed.should == true
       first_queuer.place_in_line.should == 0
      end
    end

    context "only one person in line" do
      it "should be 0" do
       line = Fabricate :line
       first_queuer = Fabricate(:queuer, line: line, name: "John", phone: "444-444-4444")

       first_queuer.process!
       first_queuer.reload.processed.should == true
       first_queuer.reload.place_in_line.should == 0
      end
    end
  end

  describe "#skip!" do

    context "first person in line is skipped" do

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

    context "person in the middle of the line is skipped" do

      it "should be 2" do
       line = Fabricate :line
       first_queuer = Fabricate(:queuer, line: line, name: "John", phone: "444-444-4444")
       line.reload
       second_queuer = Fabricate(:queuer, line: line, name: "Mary", phone: "555-555-5555")
       line.reload
       third_queuer = Fabricate(:queuer, line: line, name: "Marvin", phone: "333-333-3333")
       line.reload
       fourth_queuer = Fabricate(:queuer, line: line, name: "Marvin", phone: "615-333-4444")
       line.reload
       fifth_queuer = Fabricate(:queuer, line: line, name: "Marvin", phone: "333-444-3333")
       line.reload
       third_queuer.skip!

       first_queuer.reload.place_in_line.should == 1
       second_queuer.reload.place_in_line.should == 2
       third_queuer.reload.place_in_line.should == 4
       fourth_queuer.reload.place_in_line.should == 3
       fifth_queuer.reload.place_in_line.should == 5
      end
    end

    context "last person in line attempts to be skipped" do
     it "should be 1" do
       line = Fabricate :line
       first_queuer = Fabricate(:queuer, line: line, name: "John", phone: "444-444-4444")
       line.reload
       first_queuer.skip!
       first_queuer.reload.place_in_line.should == 1
       first_queuer.skip!.should == nil
     end
    end
  end
end
