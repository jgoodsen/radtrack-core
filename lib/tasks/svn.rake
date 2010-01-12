  namespace :svn do
    desc "Add new files to subversion"
    task :add_new_files do
       system "svn status | grep '^\?' | awk '{print $2}' | xargs svn add"
    end

    desc "Delete missing files from subversion"
    task :delete_missing_files do
       system "svn status | grep '^\!' | awk '{print $2}' | xargs svn del"
    end

    desc "shortcut for adding new files"
    task :add => [ :add_new_files ]

    desc "shortcut for adding new files"
    task :del => [ :delete_missing_files ]

    task :all => [:add, :del]
    
  end
