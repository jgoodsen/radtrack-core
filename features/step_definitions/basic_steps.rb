Given /^a baseline configuration$/ do
  Project.delete_all
  User.delete_all
  project = Factory(:project, :name => 'Project One')
  project.save!
  user = Factory(:user, :email => 'john@test.com')
  project.users << user
  user.save!
  Project.all.size.should == 1
  User.all.size.should == 1
  Project.first.users.size.should == 1
end

Given /^I am logged in as "(.*)"$/ do |email|
  @browser.goto "http://#{DOMAIN_AND_PORT}/"
  @browser.text_field(:id, 'user_session_login').set email
  @browser.text_field(:id, 'user_session_password').set "password"
  @browser.button(:name, 'commit').click
end

Given /^I am using project "(.*)"$/ do |project_name|
  @browser.link(:text, project_name).click
  @project = Project.find_by_name project_name
end

