unless Rails.env.production?
  path = File.join(Rails.root, "config/twilio.yml")
  TWILIO_CONFIG = YAML.load(File.read(path))[Rails.env] || {'sid' => '', 'from' => '', 'token' => ''}
else
  TWILIO_CONFIG = {}
  TWILIO_CONFIG['sid'] = ENV['TWILIO_SID']
  TWILIO_CONFIG['from'] = ENV['TWILIO_FROM']
  TWILIO_CONFIG['token'] = ENV['TWILIO_TOKEN']
end
