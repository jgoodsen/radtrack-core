When /^I signup as '(.*)'$/ do |login|
  @browser.open "http://#{DOMAIN_AND_PORT}/"
  @browser.click_and_wait "link=Register for a Free Beta Account"
  @browser.type "user_name", "quentin"
  @browser.type "user_email", "quentin@test.com"
  @browser.type "user_password", "quentin"
  @browser.type "user_password_confirmation", "quentin"
  @browser.click_and_wait "registration_submit"
end

Then /^I am prompted to create my first project$/ do
  assert @browser.is_text_present("You are not currently associated to any projects - enter the form below to create your first project.")
end

When /^I create the project "([^\"]*)"$/ do |project_name|
  @new_project_name = project_name
  @browser.type "project_name", @new_project_name
  @browser.click_and_wait "project_submit"
end

Then /^I see the project "(.*)" on the index page$/ do |project_name|
  assert @browser.is_text_present(project_name)
end
