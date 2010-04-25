# Based on factory girl:
#  See rdoc: http://rdoc.info/projects/thoughtbot/factory_girl
#
require 'factory_girl'

## TODO: This is a total hack but it works - when I upgraded to latest factory girl, I had to put this in
unless defined?(FACTORY_GIRL_LOADED)

  FACTORY_GIRL_LOADED = true

  Factory.sequence :email do |n|
    "person_#{n}@example.com"
  end

  Factory.sequence :login do |n|
    "username_#{n}"
  end

  Factory.sequence :project_name do |n|
    "Project_#{n}"
  end
  Factory.sequence :card_title do |n|
    "Card Title # #{n}"
  end

  Factory.define :project do |p|
    p.name { Factory.next(:project_name) }
  end

  Factory.define :user do |f|
    f.login {Factory.next(:login)}
    f.email { Factory.next(:email) }
    f.password 'password'
    f.password_confirmation 'password'
  end

  Factory.define :card do |c|
    c.title Factory.next(:card_title)
  end

  def create_user(userid)
  	Factory(:user, :login => userid)
  end

  def create_simple_project

    project = Factory(:project)

    user1 = Factory(:user)
    user1.name = "Frank"
    user2 = Factory(:user)
    user2.name = "Joe"
    project.users << user1
    project.users << user2
    user1.save!
    user2.save!

    project.cards.create(:title => Factory.next(:card_title))
    project.cards.create(:title => Factory.next(:card_title))
    project.cards.create(:title => Factory.next(:card_title))
    project.cards[0].owner = user1
    project.cards[1].owner = user2

    project.save!
    project
  end

  def create_test_project(key)
    case key
      when 'simple_project' then create_simple_project
      else raise "Could not create a test project of type #{key}"
    end
  end

end
