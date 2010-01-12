## Data that is used across runs

Given /^a simple project configuration$/ do

	User.delete_all
	Project.delete_all

	@quentin = create_user 'quentin'
	@project = Factory(:project)
	@project.users << @quentin
	@project.save!
	@quentin.save!

	@project.reload
	@quentin.reload
	@project.users.first.should == @quentin
	
end

When /^'quentin' logs in$/ do
	visits "/login"
	fills_in 'user_session_login', @quentin.login
	fills_in 'user_session_password', 'password'
	click_link 'Log in'
end

When /^navigates to project 'myproject'$/ do
  visits "/projects/#{@project.id}"
end

When /^sends a project invite to 'newuser'$/ do
  pending
end

Then /^a project invitation email is sent to 'newuser'$/ do
  pending
end

Then /^the activation code is in the email$/ do
  pending
end

Then /^the activation code is associated with the project 'myproject'$/ do
  pending
end

When /^'newuser' navigates to the registration$/ do
  pending
end

When /^enters the activation code$/ do
  pending
end

When /^'newuser' fills out the registration form$/ do
  pending
end

Then /^'newuser' is logged in$/ do
  pending
end

Then /^a project welcome email is sent to 'newuser'$/ do
  pending
end

Then /^'newuser' is a member of project 'myproject'$/ do
  pending
end

