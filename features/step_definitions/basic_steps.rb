Given /^a baseline configuration$/ do
  Factory.create_baseline_configuration
end

Given /^I am logged in as "(.*)"$/ do |email|
  @browser.goto "http://#{DOMAIN_AND_PORT}/"
  @browser.text_field(:id, 'user_session_login').set email
  @browser.text_field(:id, 'user_session_password').set "changeme"
  @browser.button(:name, 'commit').click
end

Given /^I am using project "(.*)"$/ do |project_name|
  @browser.link(:text, project_name).click
  @project = Project.find_by_name project_name
end
