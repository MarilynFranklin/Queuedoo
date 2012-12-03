require 'spec_helper'

describe SubAccountsController do
  include SmsSpec::Helpers
  include SmsSpec::Matchers
  describe "POST 'response'" do

    before do
      @line = Line.create(title: "long line")
      @user = Fabricate :user
      @line.user = @user
      @first_queuer = Queuer.create!(line_id: @line.id, name: "John", phone: "+14444444444")
      @second_queuer = Queuer.create!(line_id: @line.id, name: "Mary", phone: "+15555555555")
    end

    context "user texts 'skip me'" do

      it "should respond with 'You have been moved to the next spot in line'" do
        post :twilio_response, twiml_message(TWILIO_CONFIG['from'], "skip me", "From" => @first_queuer.phone)
        open_last_text_message_for @first_queuer.phone
        current_text_message.should have_body "You have been moved to the next spot in line"
        open_last_text_message_for @second_queuer.phone
        current_text_message.should have_body "It's your turn!"
      end

      it "should respond with 'You can't be skipped because you are the last person in line'" do
        post :twilio_response, twiml_message(TWILIO_CONFIG['from'], "skip me", "From" => @second_queuer.phone)
        open_last_text_message_for @second_queuer.phone
        current_text_message.should have_body "You can't be skipped because you are the last person in line"
      end

    end

    context "user capitalizes 'Skip Me'" do
       it "should respond with 'You have been moved to the next spot in line'" do
        post :twilio_response, twiml_message(TWILIO_CONFIG['from'], "Skip Me", "From" => @first_queuer.phone)
        open_last_text_message_for @first_queuer.phone
        current_text_message.should have_body "You have been moved to the next spot in line"
      end
    end

    context "user texts an unsupported prompt" do
       it "I'm sorry, I couldn't understand that. Text 'options' for more information" do
        post :twilio_response, twiml_message(TWILIO_CONFIG['from'], "lorem ipsum", "From" => @first_queuer.phone)
        open_last_text_message_for @first_queuer.phone
        current_text_message.should have_body "I'm sorry, I couldn't understand that. Text 'options' for more information"
      end
    end

    context "user texts 'options'" do
       it "Reply with 'skip me' if you will be late" do
        post :twilio_response, twiml_message(TWILIO_CONFIG['from'], "options", "From" => @first_queuer.phone)
        open_last_text_message_for @first_queuer.phone
        current_text_message.should have_body "Text 'skip me' if you think you will be late"
      end
    end

    context "user texts 'my place in line'" do
      it "should reply with 'Your place in line: 1" do
        post :twilio_response, twiml_message(TWILIO_CONFIG['from'], "my place in line", "From" => @first_queuer.phone)
        open_last_text_message_for @first_queuer.phone
        current_text_message.should have_body "Your place in line: 1"
      end
    end

    context "user who isn't in line texts app" do
      it "should reply with 'I'm sorry, you are not currently in line" do
        @first_queuer.process!
        post :twilio_response, twiml_message(TWILIO_CONFIG['from'], "my place in line", "From" => @first_queuer.phone)
        open_last_text_message_for @first_queuer.phone
        current_text_message.should have_body "I'm sorry, you are not currently in line"
      end
    end

    context "user's phone number is not in the database" do
      it "should not reply" do
        number = "+14231234567"
        post :twilio_response, twiml_message(TWILIO_CONFIG['from'], "my place in line", "From" => number)
        messages_for(number).should be_empty
      end
    end

    context "user who isn't in database texts 'party of 1' and line allows text to join" do
      it "should reply with 'Place in line: 3'" do
        phone = "+14231234567"
        @line.text_to_join = true
        @line.title = 'party of 1'
        @line.save!
        post :twilio_response, twiml_message(TWILIO_CONFIG['from'], "join line: party of 1. name: Jill", "From" => phone)
        open_last_text_message_for phone
        current_text_message.should have_body "Place in line: 3"
        new_queuer = Queuer.last
        new_queuer.line.should == @line
        new_queuer.user.should == @line.user
      end
    end

    context "user who is in the database texts 'party of 2' and line allows text to join" do
      it "should reply with 'Place in line: 2'" do
        @first_queuer.process!
        @line.text_to_join = true
        @line.title = 'party of 2'
        @line.save!
        post :twilio_response, twiml_message(TWILIO_CONFIG['from'], "join line: party of 2. name: Jill", "From" => @first_queuer.phone)
        open_last_text_message_for @first_queuer.phone
        current_text_message.should have_body "Place in line: 2"
        first_queuer = Queuer.find_by_phone(@first_queuer.phone)
        first_queuer.line.should == @line
        first_queuer.user.should == @line.user
      end
    end

    context "user who is in the database texts 'party of 3' and line doesn't allow text to join" do
      it "should reply with 'The owner of that line does not allow Text To Join at this time'" do
        @first_queuer.process!
        @line.title = 'party of 3'
        @line.save!
        post :twilio_response, twiml_message(TWILIO_CONFIG['from'], "join line: party of 3. name: Jill", "From" => @first_queuer.phone)
        open_last_text_message_for @first_queuer.phone
        current_text_message.should have_body "The owner of that line does not allow Text To Join at this time"
        first_queuer = Queuer.find_by_phone(@first_queuer.phone)
        first_queuer.line.should_not == @line
        first_queuer.user.should_not == @line.user
      end
    end

    context "user who isn't in line texts 'party of 4' and line doesn't allows text to join" do
      it "should not reply" do
        @line.title = 'party of 4'
        @line.save!
        post :twilio_response, twiml_message(TWILIO_CONFIG['from'], "join line: party of 4. name: Jill", "From" => "+14238888888")
        messages_for("+14238888888").should be_empty
        queuer = Queuer.last
        queuer.phone.should_not == "+14238888888"
      end
    end

  end
end
