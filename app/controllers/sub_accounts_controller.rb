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
    @queuer = Queuer.find_by_phone(params['From'])
    body = params['Body'].downcase.strip
    if body == 'skip me'
      if @queuer.skip!
        response = "You have been moved to next spot in line"
      else
        response = "You can't be skipped because you are the last person in line"
      end
    elsif body == 'options'
      response = "Text 'skip me' if you think you will be late"
    else
      response = "I'm sorry, I couldn't understand that. Text 'options' for more information"
    end
    @queuer.text(response)
    head :ok
  end

end
