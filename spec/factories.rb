require 'factory_girl'

Factory.sequence :email do |n|
  "johndoe#{n}@radtrack.com"
end

Factory.sequence :fullname do |n|
  "John Doe #{n}"
end

Factory.sequence :project_name do |n|
  "Project #{n}"
end

Factory.define :user do |u|
  email = Factory.next(:email)
  u.email email
  u.login email
  u.name Factory.next(:fullname)
  u.password "changeme"
  u.password_confirmation "changeme"
end

Factory.define :project do |p|
  p.name Factory.next(:project_name)
end

def Factory.create_baseline_configuration

  Project.delete_all
  User.delete_all
  project = Factory.build(:project, :name => 'Project One')
  project.save!
  user = Factory.build(:user, :email => 'john@test.com')
  project.users << user
  user.save!
  project.save!

  Project.all.size.should == 1
  User.all.size.should == 1
  Project.first.users.size.should == 1

end