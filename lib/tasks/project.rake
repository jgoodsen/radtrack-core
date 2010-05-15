namespace :svn do
  desc "Add new files to subversion"
  task :add_new_files do
     system "svn status | grep '^\?' | awk '{print $2}' | xargs svn add"
  end

  desc "Delete missing files from subversion"
  task :delete_missing_files do
     system "svn status | grep '^\!' | awk '{print $2}' | xargs svn del"
  end

  desc "Shortcut for adding new files"
  task :add => [ :add_new_files ]

  desc "Shortcut for adding new files"
  task :del => [ :delete_missing_files ]
  
  desc "Prints the current revision of the app to 'REVISION' in the application's root directory"
  task :revision do
    info = `svn info`.match(/Revision: (\d+)/)[1].to_i + 1
    file = File.new("#{RAILS_ROOT}/REVISION", "w")
    file.puts info
  end

  task :all => [:del, :add]
end

namespace :gems do
  namespace :install do
    task :all do
      system "rake gems:install RAILS_ENV=development"
      system "rake gems:install RAILS_ENV=test"
      system "rake gems:install RAILS_ENV=production"
      system "rake gems:install RAILS_ENV=cucumber"
    end
  end
end

namespace :db do

  desc "Re-run all migrations in both dev and test environments"
  task :remigrate do
    system "rake db:migrate VERSION=0"
    system "rake db:migrate"
    system "rake db:migrate VERSION=0 RAILS_ENV=test"
    system "rake db:migrate RAILS_ENV=test"
  end
  
  desc "Re-run all migrations in both dev and test environments"
  task :remigrate_tii_recipes_dev do
    system "rake db:migrate VERSION=0"
    system "rake db:migrate"
  end
  
end

namespace :deploy do
  desc "Copy and move assets around to where they belong in a production environment."
  task :assets do
    ## WHen we package up the css sheets in production, we need to move the images from that sheet to be relative to the production sheet
    system "mkdir -p #{RAILS_ROOT}/public/stylesheets/images"
    system "cp #{RAILS_ROOT}/public/jquery-ui-1.7.2.custom/css/default/images/* #{RAILS_ROOT}/public/stylesheets/images"
    system "cd #{RAILS_ROOT} && rake asset:packager:build_all"
  end
end

desc "Search and destroy unused image files down the public directory tree."
task :remove_unused_image_files do
  root="#{RAILS_ROOT}/public"
  search = %w{public app lib}
  files = Dir.glob("#{root}/**/*.{jpg,gif,png}")

  keepers = []
  files.each do |f|
  	name = File.basename f
  	command = "grep -rli #{name} #{search.join(' ')}"
  	results = `#{command}`
  	if results.size > 0
      puts
      puts f
      results.each do |r|
        puts "   #{r.chomp}"
      end
      puts
      keepers << f
    else
      puts "rm #{f}"
      system "rm #{f}"
  	end
  end
end 