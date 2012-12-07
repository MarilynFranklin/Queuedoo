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

    describe "#collect_digits(number)" do

      it "should only contain digits" do
        queuer =  Fabricate(:queuer, line: @line, name: "John", phone: "444-444-4444")
        queuer.collect_digits("123-456-7891").should == "1234567891"
        queuer.collect_digits("(123) 456-7891").should == "1234567891"
        queuer.collect_digits("123 456 7891").should == "1234567891"
      end
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

  describe "#attempt_skip" do

    before do
      @line = Fabricate :line
      @queuer = Fabricate(:queuer, line: @line, name: "John", phone: "+14444444444")
      @line.reload
    end

    it "should text the next queuer in line with 'It's your turn!'" do
      queuer2 = Fabricate(:queuer, line: @line, name: "Marie", phone: "+15555555555")
      @queuer.attempt_skip
      open_last_text_message_for queuer2.phone
      current_text_message.should have_body "It's your turn!"
    end

    it "should say 'You have been moved to the next spot in line" do
      queuer2 = Fabricate(:queuer, line: @line, name: "Marie", phone: "+15555555555")
      @queuer.attempt_skip.should == "You have been moved to the next spot in line"
    end

    it "should reply with 'You can't be skipped because you are the last person in line" do
      @queuer.attempt_skip.should == "You can't be skipped because you are the last person in line"
    end
  end

  describe "#next_in_line" do

    before do
      @line = Fabricate :line
      @queuer = Fabricate(:queuer, line: @line)
    end

    it "should be nil" do
      @queuer.next_in_line.should == nil
    end

    it "should be queuer2" do
      @line.reload
      queuer2 = Fabricate(:queuer, line: @line)
      @queuer.next_in_line.should == queuer2
    end
  end

  describe "#attempt_to_join(line)" do

    before do
      line = Fabricate :line
      user = Fabricate :user
      @line2 = Fabricate( :line, user: user )
      @queuer = Fabricate(:queuer, line: line)
      @queuer.process!
    end

    it "should add queuer to line2" do
      @line2.text_to_join = true
      @line2.save!
      @queuer.attempt_to_join(@line2)
      @queuer.line.should == @line2
      @queuer.place_in_line.should == 1
      @queuer.processed.should == false
    end

    it "should say 'Place in line: 1'" do
      @line2.text_to_join = true
      @line2.save!
      @queuer.attempt_to_join(@line2).should == "Place in line: #{1}"
    end

    it "should say 'The owner of that line does not allow Text To Join at this time" do
      @queuer.attempt_to_join(@line2).should == "The owner of that line does not allow Text To Join at this time"
    end

    it "should not add queuer to line2" do
      @queuer.attempt_to_join(@line2)
      @queuer.line.should_not == @line2
      @queuer.place_in_line.should == 0
      @queuer.processed.should == true
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
