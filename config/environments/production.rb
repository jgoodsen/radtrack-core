# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://radtrack.s3.amazonaws.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

REST_AUTH_SITE_KEY=''
REST_AUTH_DIGEST_STRETCHES=1

## TODO: Probably want to enable this in production!!!
config.action_controller.allow_forgery_protection    = true

DOMAIN_AND_PORT="radtrack.com"
GOOGLE_ANALYTICS_ID = "UA-10541165-2"

require 'smtp_tls'
config.action_mailer.delivery_method = :smtp
config.action_mailer.raise_delivery_errors = true
config.action_mailer.perform_deliveries = true
config.action_mailer.default_url_options   = { :host => DOMAIN_AND_PORT }

config.gem "newrelic_rpm"
