require File.dirname(__FILE__) + "/../../spec/factories"

Given /^the user 'quentin' does not exist$/ do
  User.find_by_login('quentin').delete rescue nil
end

Given /^Baseline Project "([^\"]*)"$/ do |name|
  @project = create_test_project(name)
end

Given /^User Persona "([^\"]*)"$/ do |persona|
  @user = @project.users.find_by_name(persona)
  raise "Could not find user with name #{persona } in project #{@project.name}, #{@project.users.collect(&:name).to_s}" unless @user
end

When /^I view "([^\"]*)"$/ do |view|
  case view
  when 'My Tasks' then pending
  when 'Project Kanban' then pending
    else raise "Unknown view #{view}"
  end
end
