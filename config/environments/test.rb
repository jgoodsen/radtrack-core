# Settings specified here will take precedence over those in config/environment.rb

# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

REST_AUTH_SITE_KEY=''
REST_AUTH_DIGEST_STRETCHES=1

DOMAIN_AND_PORT="localhost:3000"

config.gem 'cucumber',    :lib => false,        :version => '>=0.3.97' unless File.directory?(File.join(Rails.root, 'vendor/plugins/cucumber'))
config.gem 'webrat',      :lib => false,        :version => '>=0.5.0' unless File.directory?(File.join(Rails.root, 'vendor/plugins/webrat'))
config.gem 'rspec',       :lib => false,        :version => '>=1.2.6' unless File.directory?(File.join(Rails.root, 'vendor/plugins/rspec'))
config.gem 'rspec-rails', :lib => 'spec/rails', :version => '>=1.2.6' unless File.directory?(File.join(Rails.root, 'vendor/plugins/rspec-rails'))
config.gem "thoughtbot-factory_girl", :lib => "factory_girl", :source => "http://gems.github.com"
