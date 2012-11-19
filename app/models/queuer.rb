class Queuer < ActiveRecord::Base
  attr_accessible :line_id, :name, :phone, :processed
  
  validates_presence_of :name

  belongs_to :line

  before_save :set_place_in_line

  def set_place_in_line
    self.place_in_line ||= self.line.next_spot
  end

  def process!
    self.processed = true
    self.place_in_line = nil
    save!
    line.move_up_queuers
  end

  def move_up!
    self.place_in_line -= 1
    save!
  end

  def skip!
    self.next_in_line.move_up!
    self.place_in_line += 1
    save!
  end

  def next_in_line
    Queuer.where("place_in_line = ? AND line_id = ?", self.place_in_line + 1, self.line.id).first
  end

  def text(message)
    # Instantiate a Twilio client
    # change in production to use user's sub_account sid and token
    # http://www.twilio.com/docs/howto/subaccounts
    client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])

    # Create and send an SMS message
    client.account.sms.messages.create(

    # change from to use user's sub_account
    from: TWILIO_CONFIG['from'],
    to: self.phone,
    body: message
    )
  end

end
