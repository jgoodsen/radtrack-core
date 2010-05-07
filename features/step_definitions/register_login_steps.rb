Given /^a baseline configuration$/ do
  project = Factory(:project, :project_name => 'Project One')
  project.save!
  Project.all.size.should == 1
end

Given /^I am logged in as 'john@test\.com'$/ do
end

Given /^I am using 'Project One'$/ do
end

When /^I send an invitation to 'eric@test\.com'$/ do
end

Then /^an email is sent to 'eric@test\.com'$/ do
end

Then /^an account for 'eric@test\.com' exists$/ do
end

Then /^the account for 'eric@test\.com' is marked as pending$/ do
end

