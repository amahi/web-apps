Webapps::Engine.routes.draw do
	# root of the plugin
        root :to => 'webapps#index'
        post "/" => "webapps#create"
    resources :webapps do
		member do
			delete 'delete'
			get 'new_name_check'
			get 'new_path_check'
			put 'update_name'
			put 'update_path'
			get 'toggle_login_required'
			post 'webapp_alias_create'
			delete 'webapp_alias_destroy'
			post 'add_permission'
			delete 'remove_permission'
		end
	end
	get "permissions" => "webapps#permissions"
	# examples of controllers built in this generator. delete at will
end
