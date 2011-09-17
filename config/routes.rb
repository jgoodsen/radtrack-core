Radtrack::Application.routes.draw do

  match '/', :controller => 'welcome', :action => 'index'

  root :to => 'Welcome#index'


  resource :user_sessions
  resource :user_session, :controller => 'user_sessions'
  match '/login',  :controller => "welcome", :action => "index"
  match '/logout',  :controller => "user_sessions", :action => "destroy"

  resources :password_resets

  namespace :admin do
    resources :users
    resources :activity_logs
  end


  match '/admin/projects/:id/add_user/:user_id', :controller => 'projects', :action => 'add_user', :as => 'admin_add_user_to_project'
  match  '/admin/projects/:id/remove_user/:user_id', :controller => 'projects', :action => 'remove_user', :as => 'admin_remove_user_from_project'

  resources :projects do

    match 'settings', :controller => 'projects', :action => 'settings'
    match 'invite_user', :controller => 'projects', :action => 'invite_user'
    match 'card_dropped', :controller => 'kanban', :action => 'card_dropped'

    resources :users

    resources :boards do
      match 'reset_card_positions', :controller => 'projects', :action => 'reset_card_positions'
    end

    resources :card_states do
      match 'dropped', :controller => 'card_states', :action => 'dropped'
    end

    resources :cards do
      match 'update_attribute', :controller => 'cards', :action => 'update_attribute'
      match 'move_to_backlog', :controller => 'cards', :action => 'move_to_backlog'
      match 'backlog_card_drop', :controller => 'cards', :action => 'backlog_card_drop'
      match 'activate', :controller => 'cards', :action => 'activate'
      resources :tasks do
        match 'grabit', :controller => 'tasks', :action => 'grabit'
        match 'previous_state', :controller => 'tasks', :action => 'previous_state'
        match 'next_state', :controller => 'tasks', :action => 'next_state'
        match 'update_attribute', :controller => 'tasks', :action => 'update_attribute'
      end
    end

    match 'mytasks_tab', :controller => 'projects', :action => 'mytasks_tab'
    match 'kanban_tab', :controller => 'projects', :action => 'kanban_tab'
    match 'backlog_tab', :controller => 'projects', :action => 'backlog_tab'

  end

  resource :user_sessions
  resource :user_session, :controller => 'user_sessions'

  resources :password_resets

  resources :users

  namespace :admin do
    resources :users
    resources :activity_logs
  end

  #map.admin_add_user_to_project '/admin/projects/:id/add_user/:user_id', :controller => 'projects', :action => 'add_user'
  #map.admin_remove_user_from_project '/admin/projects/:id/remove_user/:user_id', :controller => 'projects', :action => 'remove_user'
  #
  ## Install the default routes as the lowest priority.
  # map.connect ':controller/:action/:id.:format'
  # map.connect ':controller/:action/:id'
   
end
#== Route Map
# Generated on 16 Sep 2011 00:29
#
#                               root        /(.:format)                                                           {:controller=>"Welcome", :action=>"index"}
#                      user_sessions POST   /user_sessions(.:format)                                              {:action=>"create", :controller=>"user_sessions"}
#                  new_user_sessions GET    /user_sessions/new(.:format)                                          {:action=>"new", :controller=>"user_sessions"}
#                 edit_user_sessions GET    /user_sessions/edit(.:format)                                         {:action=>"edit", :controller=>"user_sessions"}
#                                    GET    /user_sessions(.:format)                                              {:action=>"show", :controller=>"user_sessions"}
#                                    PUT    /user_sessions(.:format)                                              {:action=>"update", :controller=>"user_sessions"}
#                                    DELETE /user_sessions(.:format)                                              {:action=>"destroy", :controller=>"user_sessions"}
#                       user_session POST   /user_session(.:format)                                               {:action=>"create", :controller=>"user_sessions"}
#                   new_user_session GET    /user_session/new(.:format)                                           {:action=>"new", :controller=>"user_sessions"}
#                  edit_user_session GET    /user_session/edit(.:format)                                          {:action=>"edit", :controller=>"user_sessions"}
#                                    GET    /user_session(.:format)                                               {:action=>"show", :controller=>"user_sessions"}
#                                    PUT    /user_session(.:format)                                               {:action=>"update", :controller=>"user_sessions"}
#                                    DELETE /user_session(.:format)                                               {:action=>"destroy", :controller=>"user_sessions"}
#                              login        /login(.:format)                                                      {:controller=>"welcome", :action=>"index"}
#                             logout        /logout(.:format)                                                     {:controller=>"user_sessions", :action=>"destroy"}
#                    password_resets GET    /password_resets(.:format)                                            {:action=>"index", :controller=>"password_resets"}
#                                    POST   /password_resets(.:format)                                            {:action=>"create", :controller=>"password_resets"}
#                 new_password_reset GET    /password_resets/new(.:format)                                        {:action=>"new", :controller=>"password_resets"}
#                edit_password_reset GET    /password_resets/:id/edit(.:format)                                   {:action=>"edit", :controller=>"password_resets"}
#                     password_reset GET    /password_resets/:id(.:format)                                        {:action=>"show", :controller=>"password_resets"}
#                                    PUT    /password_resets/:id(.:format)                                        {:action=>"update", :controller=>"password_resets"}
#                                    DELETE /password_resets/:id(.:format)                                        {:action=>"destroy", :controller=>"password_resets"}
#                        admin_users GET    /admin/users(.:format)                                                {:action=>"index", :controller=>"admin/users"}
#                                    POST   /admin/users(.:format)                                                {:action=>"create", :controller=>"admin/users"}
#                     new_admin_user GET    /admin/users/new(.:format)                                            {:action=>"new", :controller=>"admin/users"}
#                    edit_admin_user GET    /admin/users/:id/edit(.:format)                                       {:action=>"edit", :controller=>"admin/users"}
#                         admin_user GET    /admin/users/:id(.:format)                                            {:action=>"show", :controller=>"admin/users"}
#                                    PUT    /admin/users/:id(.:format)                                            {:action=>"update", :controller=>"admin/users"}
#                                    DELETE /admin/users/:id(.:format)                                            {:action=>"destroy", :controller=>"admin/users"}
#                admin_activity_logs GET    /admin/activity_logs(.:format)                                        {:action=>"index", :controller=>"admin/activity_logs"}
#                                    POST   /admin/activity_logs(.:format)                                        {:action=>"create", :controller=>"admin/activity_logs"}
#             new_admin_activity_log GET    /admin/activity_logs/new(.:format)                                    {:action=>"new", :controller=>"admin/activity_logs"}
#            edit_admin_activity_log GET    /admin/activity_logs/:id/edit(.:format)                               {:action=>"edit", :controller=>"admin/activity_logs"}
#                 admin_activity_log GET    /admin/activity_logs/:id(.:format)                                    {:action=>"show", :controller=>"admin/activity_logs"}
#                                    PUT    /admin/activity_logs/:id(.:format)                                    {:action=>"update", :controller=>"admin/activity_logs"}
#                                    DELETE /admin/activity_logs/:id(.:format)                                    {:action=>"destroy", :controller=>"admin/activity_logs"}
#          admin_add_user_to_project        /admin/projects/:id/add_user/:user_id(.:format)                       {:controller=>"projects", :action=>"add_user"}
#     admin_remove_user_from_project        /admin/projects/:id/remove_user/:user_id(.:format)                    {:controller=>"projects", :action=>"remove_user"}
#                   project_settings        /projects/:project_id/settings(.:format)                              {:controller=>"projects", :action=>"settings"}
#                project_invite_user        /projects/:project_id/invite_user(.:format)                           {:controller=>"projects", :action=>"invite_user"}
#        project_kanban_card_dropped        /projects/:project_id/kanban_card_dropped(.:format)                   {:controller=>"kanban", :action=>"card_dropped"}
#                      project_users GET    /projects/:project_id/users(.:format)                                 {:action=>"index", :controller=>"users"}
#                                    POST   /projects/:project_id/users(.:format)                                 {:action=>"create", :controller=>"users"}
#                   new_project_user GET    /projects/:project_id/users/new(.:format)                             {:action=>"new", :controller=>"users"}
#                  edit_project_user GET    /projects/:project_id/users/:id/edit(.:format)                        {:action=>"edit", :controller=>"users"}
#                       project_user GET    /projects/:project_id/users/:id(.:format)                             {:action=>"show", :controller=>"users"}
#                                    PUT    /projects/:project_id/users/:id(.:format)                             {:action=>"update", :controller=>"users"}
#                                    DELETE /projects/:project_id/users/:id(.:format)                             {:action=>"destroy", :controller=>"users"}
# project_board_reset_card_positions        /projects/:project_id/boards/:board_id/reset_card_positions(.:format) {:controller=>"projects", :action=>"reset_card_positions"}
#                     project_boards GET    /projects/:project_id/boards(.:format)                                {:action=>"index", :controller=>"boards"}
#                                    POST   /projects/:project_id/boards(.:format)                                {:action=>"create", :controller=>"boards"}
#                  new_project_board GET    /projects/:project_id/boards/new(.:format)                            {:action=>"new", :controller=>"boards"}
#                 edit_project_board GET    /projects/:project_id/boards/:id/edit(.:format)                       {:action=>"edit", :controller=>"boards"}
#                      project_board GET    /projects/:project_id/boards/:id(.:format)                            {:action=>"show", :controller=>"boards"}
#                                    PUT    /projects/:project_id/boards/:id(.:format)                            {:action=>"update", :controller=>"boards"}
#                                    DELETE /projects/:project_id/boards/:id(.:format)                            {:action=>"destroy", :controller=>"boards"}
#         project_card_state_dropped        /projects/:project_id/card_states/:card_state_id/dropped(.:format)    {:controller=>"card_states", :action=>"dropped"}
#                project_card_states GET    /projects/:project_id/card_states(.:format)                           {:action=>"index", :controller=>"card_states"}
#                                    POST   /projects/:project_id/card_states(.:format)                           {:action=>"create", :controller=>"card_states"}
#             new_project_card_state GET    /projects/:project_id/card_states/new(.:format)                       {:action=>"new", :controller=>"card_states"}
#            edit_project_card_state GET    /projects/:project_id/card_states/:id/edit(.:format)                  {:action=>"edit", :controller=>"card_states"}
#                 project_card_state GET    /projects/:project_id/card_states/:id(.:format)                       {:action=>"show", :controller=>"card_states"}
#                                    PUT    /projects/:project_id/card_states/:id(.:format)                       {:action=>"update", :controller=>"card_states"}
#                                    DELETE /projects/:project_id/card_states/:id(.:format)                       {:action=>"destroy", :controller=>"card_states"}
#                project_mytasks_tab        /projects/:project_id/mytasks_tab(.:format)                           {:controller=>"projects", :action=>"mytasks_tab"}
#                 project_kanban_tab        /projects/:project_id/kanban_tab(.:format)                            {:controller=>"projects", :action=>"kanban_tab"}
#                project_backlog_tab        /projects/:project_id/backlog_tab(.:format)                           {:controller=>"projects", :action=>"backlog_tab"}
#                           projects GET    /projects(.:format)                                                   {:action=>"index", :controller=>"projects"}
#                                    POST   /projects(.:format)                                                   {:action=>"create", :controller=>"projects"}
#                        new_project GET    /projects/new(.:format)                                               {:action=>"new", :controller=>"projects"}
#                       edit_project GET    /projects/:id/edit(.:format)                                          {:action=>"edit", :controller=>"projects"}
#                            project GET    /projects/:id(.:format)                                               {:action=>"show", :controller=>"projects"}
#                                    PUT    /projects/:id(.:format)                                               {:action=>"update", :controller=>"projects"}
#                                    DELETE /projects/:id(.:format)                                               {:action=>"destroy", :controller=>"projects"}
#                                    POST   /user_sessions(.:format)                                              {:action=>"create", :controller=>"user_sessions"}
#                                    GET    /user_sessions/new(.:format)                                          {:action=>"new", :controller=>"user_sessions"}
#                                    GET    /user_sessions/edit(.:format)                                         {:action=>"edit", :controller=>"user_sessions"}
#                                    GET    /user_sessions(.:format)                                              {:action=>"show", :controller=>"user_sessions"}
#                                    PUT    /user_sessions(.:format)                                              {:action=>"update", :controller=>"user_sessions"}
#                                    DELETE /user_sessions(.:format)                                              {:action=>"destroy", :controller=>"user_sessions"}
#                                    POST   /user_session(.:format)                                               {:action=>"create", :controller=>"user_sessions"}
#                                    GET    /user_session/new(.:format)                                           {:action=>"new", :controller=>"user_sessions"}
#                                    GET    /user_session/edit(.:format)                                          {:action=>"edit", :controller=>"user_sessions"}
#                                    GET    /user_session(.:format)                                               {:action=>"show", :controller=>"user_sessions"}
#                                    PUT    /user_session(.:format)                                               {:action=>"update", :controller=>"user_sessions"}
#                                    DELETE /user_session(.:format)                                               {:action=>"destroy", :controller=>"user_sessions"}
#                                    GET    /password_resets(.:format)                                            {:action=>"index", :controller=>"password_resets"}
#                                    POST   /password_resets(.:format)                                            {:action=>"create", :controller=>"password_resets"}
#                                    GET    /password_resets/new(.:format)                                        {:action=>"new", :controller=>"password_resets"}
#                                    GET    /password_resets/:id/edit(.:format)                                   {:action=>"edit", :controller=>"password_resets"}
#                                    GET    /password_resets/:id(.:format)                                        {:action=>"show", :controller=>"password_resets"}
#                                    PUT    /password_resets/:id(.:format)                                        {:action=>"update", :controller=>"password_resets"}
#                                    DELETE /password_resets/:id(.:format)                                        {:action=>"destroy", :controller=>"password_resets"}
#                              users GET    /users(.:format)                                                      {:action=>"index", :controller=>"users"}
#                                    POST   /users(.:format)                                                      {:action=>"create", :controller=>"users"}
#                           new_user GET    /users/new(.:format)                                                  {:action=>"new", :controller=>"users"}
#                          edit_user GET    /users/:id/edit(.:format)                                             {:action=>"edit", :controller=>"users"}
#                               user GET    /users/:id(.:format)                                                  {:action=>"show", :controller=>"users"}
#                                    PUT    /users/:id(.:format)                                                  {:action=>"update", :controller=>"users"}
#                                    DELETE /users/:id(.:format)                                                  {:action=>"destroy", :controller=>"users"}
#                                    GET    /admin/users(.:format)                                                {:action=>"index", :controller=>"admin/users"}
#                                    POST   /admin/users(.:format)                                                {:action=>"create", :controller=>"admin/users"}
#                                    GET    /admin/users/new(.:format)                                            {:action=>"new", :controller=>"admin/users"}
#                                    GET    /admin/users/:id/edit(.:format)                                       {:action=>"edit", :controller=>"admin/users"}
#                                    GET    /admin/users/:id(.:format)                                            {:action=>"show", :controller=>"admin/users"}
#                                    PUT    /admin/users/:id(.:format)                                            {:action=>"update", :controller=>"admin/users"}
#                                    DELETE /admin/users/:id(.:format)                                            {:action=>"destroy", :controller=>"admin/users"}
#                                    GET    /admin/activity_logs(.:format)                                        {:action=>"index", :controller=>"admin/activity_logs"}
#                                    POST   /admin/activity_logs(.:format)                                        {:action=>"create", :controller=>"admin/activity_logs"}
#                                    GET    /admin/activity_logs/new(.:format)                                    {:action=>"new", :controller=>"admin/activity_logs"}
#                                    GET    /admin/activity_logs/:id/edit(.:format)                               {:action=>"edit", :controller=>"admin/activity_logs"}
#                                    GET    /admin/activity_logs/:id(.:format)                                    {:action=>"show", :controller=>"admin/activity_logs"}
#                                    PUT    /admin/activity_logs/:id(.:format)                                    {:action=>"update", :controller=>"admin/activity_logs"}
#                                    DELETE /admin/activity_logs/:id(.:format)                                    {:action=>"destroy", :controller=>"admin/activity_logs"}
