# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Meetingup::Application.initialize!
Paperclip.options[:command_path] = "/usr/bin/convert"
