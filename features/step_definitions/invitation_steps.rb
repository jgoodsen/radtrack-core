def goto_project_tab(id)
  @browser.link(:id, "#{id}_tab").click
  @browser.goto "http://#{DOMAIN_AND_PORT}/projects/#{@project.id}##{id}"
end
  
When /^I send an invitation to "([^\"]*)"$/ do |email|
  goto_project_tab("members")
  @browser.button(:id, "invite_user_button").click
  @browser.text_field(:id, "user_email").set email
  @browser.button(:id, "invite_user_submit").click
end

Then /^an email is sent to "([^\"]*)"$/ do |email|
end

Then /^an account for "([^\"]*)" exists$/ do |email|
end

Then /^the account for "([^\"]*)" is marked as pending$/ do |email|
end
