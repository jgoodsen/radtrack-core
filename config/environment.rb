# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.1.0' if ENV['RAILS_ENV'] == 'production'
RAILS_GEM_VERSION = '2.3.5' unless defined?(RAILS_GEM_VERSION) || ENV['RAILS_ENV'] == 'production'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use. To use Rails without a database
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Specify gems that this application depends on. 
  # They can then be installed with "rake gems:install" on new installations.
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "aws-s3", :lib => "aws/s3"
  # config.gem 'openssl'
  # config.gem 'mislav-will_paginate', :version => '~> 2.3.2', :lib => 'will_paginate', :source => 'http://gems.github.com'

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Uncomment to use default local time.
  config.time_zone = 'UTC'

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_xcards_session',
    :secret      => '4ecc0a1e73c51fc67aeb558f1d0d4e8e6cb2af734e6d099994ecca36aa5dae1b4538a7b1bc5bd05e3287fc930f24dafb21186e986e673aa2aa2b03bfa4456b33'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with "rake db:sessions:create")
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector
  # config.active_record.observers = :user_observer

  config.gem "authlogic"
  config.gem 'will_paginate'

  # Searches for all gems in the /vendor/gems directory adds them to
  # the load path.  All gems must still be required for them to work.
  config.load_paths += Dir["#{RAILS_ROOT}/vendor/gems/**"].map do |dir| 
    File.directory?(lib = "#{dir}/lib") ? lib : dir
  end
  
end

## TODO: Remove this bitwise feature exposure experiment
BETA_USERS=['admin@radtrack.com', 'admin', 'jgoodsen', 'jgoodsen@radsoft.com', 'dudeblak@gmail.com', 'curtis.cooley@gmail.com', 'jhno', 'pdale', 'bschnorf', 'jeff.kondas@gmail.com']

if File.exist?("#{RAILS_ROOT}/config/smtp_config.rb")
  require "#{RAILS_ROOT}/config/smtp_config.rb"
else
  DEFAULT_SMTP_TEMPLATE="#{RAILS_ROOT}/config/smtp_config_template.rb"
  puts "WARNING: Using default smtp configuration template - which may or may not be valid: #{DEFAULT_SMTP_TEMPLATE}"
  puts File.read(DEFAULT_SMTP_TEMPLATE)
  puts "To fix this, run the command 'cp config/smtp_config_template.rb config/smtp_config.rb && mate config/smtp_config.rb'
  require "#{RAILS_ROOT}/config/smtp_config_template.rb"
end
