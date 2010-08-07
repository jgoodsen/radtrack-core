namespace :faker do
  desc 'Create a huge amount of users'
  task :populate_users => :environment do
    (1..100).each do |i|
      email = "johndoe#{i}@foo.com"
      password = "changeme"
      User.create(:email => email, :login => email, :password => password, :password_confirmation => password )
    end
  end
end
