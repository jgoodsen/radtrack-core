default_run_options[:pty] = true
set :scm, "git"
set :repository,  "git@github.com:jgoodsen/radtrack-core.git"

ssh_options[:forward_agent] = true
set :branch, "master"
set :scm_verbose, true 
set :git_shallow_clone, 1

set :rails_env, "production"
set :application, "radtrack"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/apps/#{application}"

role :app, "radtrack.com"
role :web, "radtrack.com"
role :db,  "radtrack.com", :primary => true

## The account on radtrack.com that we do deployment under
set :user, 'admin'
set :runner, 'admin'

ssh_options[:keys] = %w(/Users/jgoodsen/.ssh/id_rsa)

desc "tail production log files" 
task :tail_logs, :roles => :app do
  run "tail -f #{shared_path}/log/production.log" do |channel, stream, data|
    puts  # for an extra line break before the host name
    puts "#{channel[:host]}: #{data}" 
    break if stream == :err    
  end
end

namespace :deploy do
 desc "Create asset packages for production" 
 task :after_update_code, :roles => [:app, :db, :web] do
   # run <<-EOF
   #   cd #{release_path} && rake deploy:assets
   # EOF
   run "ln -nfs #{deploy_to}/shared/config/production.rb #{deploy_to}/releases/#{release_name}/config/environments/production.rb" 
   run "ln -nfs #{deploy_to}/shared/config/database.yml #{deploy_to}/releases/#{release_name}/config/database.yml" 
   run "ln -nfs #{deploy_to}/shared/config/smtp_config.rb #{deploy_to}/releases/#{release_name}/config/smtp_config.rb"
   run "ln -nfs #{deploy_to}/shared/config/newrelic.yml #{deploy_to}/releases/#{release_name}/config/newrelic.yml"
 
   ## TODO: Only a temporary Hack as we run Rails 2.1.0 on slicehost
   run "ln -nfs #{deploy_to}/releases/#{release_name}/app/controllers/application_controller.rb #{deploy_to}/releases/#{release_name}/app/controllers/application.rb"
 
 end
 
 task :restart do
   run "sh restart_mongrels"
 end
 
end

task :restart_mongrels do
  run "sh restart_mongrels"
end

task :backup do
  run "mysqldump -u root radtrack_production > /tmp/radtrack.sql"
  system "scp admin@radtrack.com:/tmp/radtrack.sql /tmp/radtrack.sql"
end


Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end
