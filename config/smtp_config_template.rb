##
## This is the template configuration file for your SMTP configuration
## copy it to config/smtp_config.rb and edit it that file with your private smtp information.
## Be careful to never check files with private information to github.
##
ActionMailer::Base.smtp_settings = {
    :enable_starttls_auto => true,
    :address => "smtp.gmail.com",
    :port => "587",
    :domain => "yourdomain.com",
    :authentication => :plain,
    :user_name => "your username",
    :password => "yourpassword" 
  }
