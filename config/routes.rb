Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :products do
      resources :digitals, :digital_samples
    end
  end
  
 
  
  get '/digital/:secret', :to => 'digitals#show', :via => :get, :as => 'digital', :constraints => { :secret => /[a-zA-Z0-9]{30}/ }
#  get '/public/digital_samples/:id/:basename.:extension'
  
  
end