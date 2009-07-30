ActionController::Routing::Routes.draw do |map|
  map.resources :users
  map.resource :account, :controller => "users"
  map.resource :user_session
  
  # map.signup '/signup', :controller => "users", :action => "new"
  map.signin '/signin', :controller => "user_sessions", :action => "new"
  map.signout '/signout', :controller => "user_sessions", :action => "destroy"
end
