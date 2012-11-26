class SubAccountsController < ApplicationController
  protect_from_forgery :except => ["create"]

  # Can't create sub_accounts with Twilio's test credentials
  # waiting till in production
  # def new
  #   @sub_account = SubAccount.new
  # end

  # def create
    # @sub_account = SubAccount.new
    # @sub_account.user = current_user 
    # if @sub_account.save
    #   flash[:notice] = "Your account has been set up"
    #   redirect_to lines_path
    # end
  # end

  def twilio_response
    if @queuer = Queuer.find_by_formatted_number(params['From'])
      body = params['Body'].downcase.strip
      if @queuer.processed
        response = "I'm sorry, you are not currently in line"
      elsif body == 'skip me'
        if @queuer.skip!
          response = "You have been moved to the next spot in line"
        else
          response = "You can't be skipped because you are the last person in line"
        end
      elsif body == 'options'
        response = "Text 'skip me' if you think you will be late"
      elsif body == 'my place in line'
        response = "Your place in line: #{@queuer.place_in_line}"
      else
        response = "I'm sorry, I couldn't understand that. Text 'options' for more information"
      end
      @queuer.text(response)
    end
      head :status => :ok
  end

end
