class Queuer < ActiveRecord::Base
  attr_accessible :line_id, :name, :phone, :processed, :user_id, :place_in_line
  
  validates_presence_of :name
  validates :phone, presence:true,
            format: {:with => /\(?([0-9]{3})\)?([ .-]?)([0-9]{3})\2([0-9]{4})/,
            message: "Please enter a valid phone number" }

  belongs_to :line
  belongs_to :user, foreign_key: 'user_id'

  before_save :set_place_in_line, :set_formatted_number

  def add_to_line(line)
    self.update_attributes(line_id: line.id, processed: false, place_in_line: line.next_spot)
  end

  def attempt_skip
    if skip!
      line.first_queuer.text("It's your turn!")
      "You have been moved to the next spot in line"
    else
      "You can't be skipped because you are the last person in line"
    end
  end

  def attempt_to_join(line)
    if line.text_to_join
      self.update_attributes( line_id: line.id, user_id: line.user.id, processed: false, place_in_line: line.next_spot )
      "Place in line: #{place_in_line}"
    else
      "The owner of that line does not allow Text To Join at this time"
    end
  end

  def collect_digits(phone_number)
    phone_number.scan(/\d+/).join
  end

  def format_number(phone_number)
    # +1 is added as the international code
    # Used when receiving calls through twilio
    collect_digits(phone_number).size == 10 ? international_code = "+1" : international_code = "+"
    formatted_number = "#{international_code}#{collect_digits(phone_number)}"
  end

  def generate_response(message)
    return "I'm sorry, you are not currently in line" if processed && !/^join line/.match(message)
    case message
    when /^join line: (.*?). name: (.*?)$/
      line = Line.find(:all, :conditions => ['title LIKE ?', "%#{$1}%"]).first
      attempt_to_join(line)
    when 'skip me'
      attempt_skip
    when 'options'
      "Text 'skip me' if you think you will be late"
    when 'my place in line'
      "Your place in line: #{place_in_line}"
    else
       "I'm sorry, I couldn't understand that. Text 'options' for more information"
    end
  end

  def last?
    next_in_line ? false : true
  end

  def move_up!
    self.update_attributes( place_in_line: place_in_line - 1 )
  end

  def next_in_line
    line.unprocessed_queuers.find_by_place_in_line( place_in_line + 1 )
  end

  def next_queuers
    line.unprocessed_queuers.where( "place_in_line > ?", place_in_line )
  end

  def process!
    line.move_up_queuers_behind(self)
    self.update_attributes( processed: true, place_in_line: 0 )
    self.line = nil
    save!
  end

  def set_formatted_number
    self.formatted_number = format_number(phone)
  end

  def set_place_in_line
    self.place_in_line ||= self.line.next_spot
  end

  def skip!
    if next_in_line
      next_in_line.move_up!
      self.update_attributes( place_in_line: place_in_line + 1 )
    else
      nil
    end
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
