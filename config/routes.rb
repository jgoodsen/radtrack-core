ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'welcome', :action => 'index'
  
  map.resource :user_sessions  
  map.resource :user_session, :controller => 'user_sessions'  
  map.login "login", :controller => "welcome", :action => "index"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  map.resources :password_resets
  
  map.resources :users

  map.namespace :admin do |admin|
    admin.resources :users
    admin.resources :activity_logs
  end
  map.admin_add_user_to_project '/admin/projects/:id/add_user/:user_id', :controller => 'projects', :action => 'add_user' 
  map.admin_remove_user_from_project '/admin/projects/:id/remove_user/:user_id', :controller => 'projects', :action => 'remove_user' 
  
  ## Sometimes we need to do things with all of our cards, outside of a particular project, in a RESTful manne
  map.resources :cards do |card|
    card.resources :tasks
  end
  
  map.resources :projects   do |project|

    project.settings 'settings', :controller => 'projects', :action => 'settings'
    project.invite_user 'invite_user', :controller => 'projects', :action => 'invite_user'

    project.kanban_card_dropped 'card_dropped', :controller => 'kanban', :action => 'card_dropped'

    project.resources :users
    project.resources :card_states do |card_state|
      card_state.dropped 'dropped', :controller => 'card_states', :action => 'dropped'
    end
    
    project.resources :cards do |card|
      card.update_attribute 'update_attribute', :controller => 'cards', :action => 'update_attribute'
      card.backlog_card_drop 'move_to_backlog', :controller => 'cards', :action => 'move_to_backlog'
      card.backlog_card_drop 'backlog_card_drop', :controller => 'cards', :action => 'backlog_card_drop'
      card.activate 'activate', :controller => 'cards', :action => 'activate'
      card.resources :tasks do |task|
        task.grabit 'grabit', :controller => 'tasks', :action => 'grabit'
        task.previous_state 'previous_state', :controller => 'tasks', :action => 'previous_state'
        task.next_state 'next_state', :controller => 'tasks', :action => 'next_state'
      end
    end
    
    project.test_backlog 'test_backlog', :controller => 'projects', :action => 'test_backlog'
    project.test_backlog 'test_kanban', :controller => 'projects', :action => 'test_kanban'
    
    project.mytasks_tab 'mytasks_tab', :controller => 'projects', :action => 'mytasks_tab'
    project.kanban_tab 'kanban_tab', :controller => 'projects', :action => 'kanban_tab'
    project.backlog_tab 'backlog_tab', :controller => 'projects', :action => 'backlog_tab'
    
  end

  
  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
  
end
