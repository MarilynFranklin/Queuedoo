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
    body = params['Body'].downcase.strip
    subaccount = SubAccount.new
    if @queuer = Queuer.find_by_formatted_number(params['From'])
      response = @queuer.generate_response(body)
      @queuer.text(response)
    else
      if message = subaccount.parse(body)
        # in production: find user where their subaccount twilio number matches params['To']
        # then query for a line that has the requested title and belongs to the user account
        # and remove :all from the find parameter below
        @line = Line.find(:all, :conditions => ['title LIKE ?', "%#{message[:title]}%"]).first
        return head status: :ok unless @line.text_to_join
        guest = Queuer.create!(name: message[:name], phone: params['From'], line_id: @line.id)
        guest.text("Place in line: #{guest.place_in_line}")
      end
    end
      head :status => :ok
  end

end
