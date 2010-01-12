namespace :git do
  desc "Add new files to subversion"
  task :backup do
     files = []
     IO.popen("git status") do |io|
      io.each do |line|
        if line =~ /^#.*(modified|new file):(.*)/
          files <<  $2.strip
        end
      end
    end
    command = "tar czvf ../radtrack-git-backup.tgz " + files.collect {|f| " #{f}"}.to_s
    puts command
    system command
  end
end
