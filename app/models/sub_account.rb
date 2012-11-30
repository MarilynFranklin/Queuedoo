class SubAccount < ActiveRecord::Base
  # before_save :create_twilio_subaccount
  attr_accessible :user_id

  belongs_to :user

  # Waiting till in production to create Twilio subaccounts
  # http://www.twilio.com/docs/howto/subaccounts
  # def create_twilio_subaccount     
  #   @client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])
  #   @subaccount = @client.accounts.create({:FriendlyName => self.user.email})
  #   self.twilio_account_sid = @subaccount.sid
  #   self.twilio_auth_token  = @subaccount.auth_token
  # end

  def parse(message)
    if message =~ /^join line: (.*?). name: (.*?)$/
      { title: $1, name: $2 }
    end
  end
end
