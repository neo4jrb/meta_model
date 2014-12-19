Rails.application.routes.draw do

  namespace :meta do
    resources :models, param: :class_name do
      collection do
        get :hierarchy
      end
    end
    resources :properties
    resources :associations#, path: '/associations'#, param: :asso
    root 'models#index'
  end


  resources :models, path: '/:model'

  root 'models#meta_index'#, as: :meta_models

end
