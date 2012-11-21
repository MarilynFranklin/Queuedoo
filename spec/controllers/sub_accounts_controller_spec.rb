require 'spec_helper'

describe SubAccountsController do
  include SmsSpec::Helpers
  include SmsSpec::Matchers
  describe "POST 'response'" do

    before do
      line = Line.create(title: "long line")
      @first_queuer = Queuer.create!(line_id: line.id, name: "John", phone: "+14444444444")
      @second_queuer = Queuer.create!(line_id: line.id, name: "Mary", phone: "+15555555555")
    end

    context "user texts 'skip me'" do

      it "should respond with 'You have been moved to the next spot in line'" do
        post :twilio_response, twiml_message(TWILIO_CONFIG['from'], "skip me", "From" => @first_queuer.phone)
        open_last_text_message_for @first_queuer.phone
        current_text_message.should have_body "You have been moved to the next spot in line"
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

  end
end
