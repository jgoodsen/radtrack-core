# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# config.action_controller.asset_host                  = "http://assets.example.com"

config.action_controller.allow_forgery_protection    = true

REST_AUTH_SITE_KEY=''
REST_AUTH_DIGEST_STRETCHES=1

DOMAIN_AND_PORT="127.0.0.1:3000"
config.action_mailer.default_url_options = {
  :host => '127.0.0.1',
  :port => 3000
}

require 'smtp_tls'
config.action_mailer.delivery_method = :smtp
config.action_mailer.raise_delivery_errors = true
config.action_mailer.perform_deliveries = true
config.action_mailer.default_url_options   = { :host => DOMAIN_AND_PORT }

config.gem 'cucumber',    :lib => false,        :version => '>=0.3.97' unless File.directory?(File.join(Rails.root, 'vendor/plugins/cucumber'))
config.gem 'rspec',       :lib => false,        :version => '>=1.2.6' unless File.directory?(File.join(Rails.root, 'vendor/plugins/rspec'))
config.gem 'rspec-rails', :lib => 'spec/rails', :version => '>=1.2.6' unless File.directory?(File.join(Rails.root, 'vendor/plugins/rspec-rails'))
config.gem "thoughtbot-factory_girl", :lib => "factory_girl", :source => "http://gems.github.com"
