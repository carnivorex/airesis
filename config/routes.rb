DemocracyOnline3::Application.routes.draw do
  
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks"} do
    
    get '/users/sign_in' , :to => 'devise/sessions#new'  
    get '/users/sign_out', :to => 'devise/sessions#destroy'
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  end
 
  

  root :to => 'proposals#index'
  resources :users                                      
  
  resources :proposal_comments
  
  resources :proposals do
    resources :proposal_comments
  end
  
  resources :proposalcategories
  
  resources :blogs do 
    resources :blog_posts do
      match :tag, :on => :member
      match :drafts, :on => :collection 
      resources :blog_comments
    end
  end
  
  resources :blog_posts
  
   resources :events 
  
  match '/groups/partecipation_request_confirm', :to => 'groups#partecipation_request_confirm'
  match '/groups/ask_for_follow', :to => 'groups#ask_for_follow'
  resources :groups

  
  match ':controller/:action/'
    
  resources :admin
  match 'admin_panel', :to => 'admin#show', :as => 'admin/panel'

  match '/votation/', :to => 'votations#show'
  match '/votation/vote', :to => 'votations#vote'
  resources :votations

  match ':controller/:action/:id'
  
  match ':controller/:action/:id.:format'
  
#  map.resources :blogs,
  
   match 'index_by_category', :to => 'proposals#index_by_category', :as => '/proposals/index_by_category'
  
  # match 'activate', :to  => 'users#activate', :as => '/activate/:activation_code'
   
  #  map.signup '/signup', :controller => 'users', :action => 'new'
#    map.login  '/login', :controller => 'sessions', :action => 'new'
 #   map.logout '/logout', :controller => 'sessions', :action => 'destroy'
#   match 'forgot_password', :to => 'users#forgot_password', :as => '/forgot_password'
  #  map.reset_password '/reset_password/:id', :controller => 'users', 
    #                                          :action => 'reset_password'       
                                              
 #   map.new_session '/login', :controller => 'sessions', :action => 'new'                 
end