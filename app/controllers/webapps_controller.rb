class WebappsController < ApplicationController
	before_filter :admin_required



	def index
		@webapps = Webapp.all
	end

	def create
		name = params[:webapp][:name].strip
		path = params[:webapp][:path].sub(/\/+$/, '')
		path.gsub!(/\/+/, '/')
		@wa = Webapp.create(:name => name, :path => path)
		@webapps = Webapp.all
		# render :partial => 'content'
	end

	def delete
		wa = Webapp.find params[:id]
		wa.destroy
		@webapps = Webapp.all
	end

	def new_name_check(n)
		if n.nil? or n.blank?
			return false
		end
		if (not (valid_name?(n))) or (n.size > 32)
			return false
		end
		n = n.strip
		a = DnsAlias.where(:name => n).first
		if a.nil?
			# no such alias, ok to create it
			return true
		else
			return false
		end
	end

	def new_path_check(n)
		if n.nil? or n.blank?
			return false
		end
		unless valid_path?(n)
			return false
		end
		return true
	end

	def update_name
		id = params[:id]
		wa = Webapp.find(id)
		status = 'notok'
		unless params[:name].blank?
			name = params[:name]
			if new_name_check(name)
				if wa.update_attributes(:name=>name)
					status = 'ok'
				end
			else
				status = "notok"
			end
		end
		@webapp = wa
	end

	def update_path
		id = params[:id]
		wa = Webapp.find(id)
		unless params[:path].blank?
			path = params[:path]
			if new_path_check(path)
			# check it exists!
				if files_exist?(path)
					check = true
					wa.path = path
					wa.save!
					status = "ok"
				else
					# FIXME - report (somehow) why we did not
					# make it! user must be confused!?!
					# alternatively, create it!
					status = "notok"
				end
			else
				status = "notok"
			end
		end
		@webapp = wa
	end

	def toggle_login_required
		begin
			webapp = Webapp.find params[:id]
			webapp.login_required = ! webapp.login_required
			webapp.save
		rescue
		end
		render :json => {:status => 'ok'}
	end


	def webapp_alias_create
		@webapp = Webapp.find params[:id]
		raise "Webapp with id=#{params[:id]} cannot be found" unless @webapp
		@waa = WebappAlias.where(:name=>params[:name]).first
		if @waa
			prev = @waa.webapp_id
			@waa.webapp_id = @webapp.id
			@waa.save!
			Webapp.find(prev).save
		else
			@waa = WebappAlias.create(:name => params[:name], :webapp_id => @webapp.id)
		end

	end

	def webapp_alias_destroy
		@waa = WebappAlias.find(params[:id])
		id = @waa.webapp_id
		@waa.destroy if @waa
		@webapp = Webapp.find(id)
		return unless @waa
	end

private

	def valid_name?(nm)
		return false unless (nm =~ /\A[A-Za-z][A-Za-z0-9\-]+\z/)
		true
	end

	def valid_path?(path)
		return false if path.size > 250
		return false unless path =~ /^\//
		return false unless path =~ /\A[A-Za-z0-9_\/-]+\z/
		return false if path =~ /\/$/
		return false if path =~ /\/\/+/
		true
	end

	def files_exist?(path)
		return false unless File.exist?(path)
		return false unless File.exist?(File.join(path, "html"))
		return false unless File.exist?(File.join(path, "logs"))
		true
	end
end
