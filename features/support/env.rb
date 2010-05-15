require 'rubygems'
# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] ||= "cucumber"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails/world'
Cucumber::Rails::World.use_transactional_fixtures = false

require 'spec/expectations'
require 'factory_girl'
require File.expand_path(File.dirname(__FILE__) + '/../../spec/factories')

if ENV['FIREWATIR']
  require 'firewatir'
  Browser = FireWatir::Firefox
else
  case RUBY_PLATFORM
  when /darwin/
    require 'safariwatir'
    Browser = Watir::Safari
  when /win32|mingw/
    require 'watir'
    Browser = Watir::IE
  when /java/
    require 'celerity'
    Browser = Celerity::Browser
  else
    raise "This platform is not supported (#{PLATFORM})"
  end
end


# "before all"
browser = Browser.new

Before do	
  @browser = browser
end

# "after all"
at_exit do
  #browser.close
end

