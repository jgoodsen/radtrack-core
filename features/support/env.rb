require 'spec/expectations'
require 'selenium'

# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] ||= "cucumber"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails/world'

# "before all"
browser = Selenium::SeleniumDriver.new("localhost", 4444, "*chrome", "http://localhost", 15000)
browser.start

module Selenium
  class SeleniumDriver
    def click_and_wait(locator)
      click locator
      wait_for_page_to_load
    end
  end
end
    
Before do
  @browser = browser
  @browser.set_speed 500
end

After do
end

# "after all"
at_exit do
  browser.stop
  browser.close rescue nil
end
