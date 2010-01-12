namespace :db do
  namespace :backup do
    
    def interesting_tables
      ActiveRecord::Base.connection.tables.sort.reject do |tbl|
        ['schema_migrations', 'sessions', 'public_exceptions'].include?(tbl)
      end
    end
  
    desc "Dump entire db to the db/backup directory."
    task :write => :environment do 

      dir = RAILS_ROOT + '/db/backup'
      FileUtils.mkdir_p(dir)
      FileUtils.chdir(dir)

      interesting_tables.each do |tbl|

        klass = tbl.classify.constantize
        puts "Writing #{tbl}..."
        File.open("#{tbl}.yml", 'w+') { |f| YAML.dump klass.find(:all).collect(&:attributes), f }      
      end
    
    end
  
    desc "Loads previously backed up data created by the db:backup:write task"
    task :read => [:environment, 'db:schema:load'] do 

      dir = RAILS_ROOT + '/db/backup'
      FileUtils.mkdir_p(dir)
      FileUtils.chdir(dir)
    
      interesting_tables.each do |tbl|

        klass = tbl.classify.constantize
        ActiveRecord::Base.transaction do 
        
          puts "Loading #{tbl}..."
          YAML.load_file("#{tbl}.yml").each do |fixture|
            ActiveRecord::Base.connection.execute "INSERT INTO #{tbl} (#{fixture.keys.join(",")}) VALUES (#{fixture.values.collect { |value| ActiveRecord::Base.connection.quote(value) }.join(",")})", 'Fixture Insert'
          end        
        end
      end
    
    end

    def load_backup(project, tbl, fields)
      dir = RAILS_ROOT + '/db/backup'
      FileUtils.mkdir_p(dir)
      FileUtils.chdir(dir)
      ActiveRecord::Base.transaction do 
        klass = tbl.classify.constantize
        puts "Loading #{tbl}..."
        YAML.load_file("#{dir}/#{tbl}.yml").each do |fixture|
          fixture.delete_if {|k, v| ! fields.include?(k)}
          obj = project.current_release.cards.build(fixture)
          obj.project = project
          obj.save!
          obj.update_attributes(fixture)
          obj.save!
          puts obj.title
        end        
      end
    end
    
  end

  desc "Loads sample project data into the system"
  task :load_sample_project => [:environment, 'db:schema:load'] do 
    Project.delete_all
    CardType.init
    admin = User.create_admin_user
    guest = User.create_guest_user
    project = Project.new(:name => "My Super Duper Test Project")
    guest.projects << project
    admin.projects << project
    admin.save!
    guest.save!
    load_backup(project, 'cards', ['title', 'description'])
    puts "\n----------------\nSample Data Loaded. You can login as guest/password to see the sample data."
  end

end

