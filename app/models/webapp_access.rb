# Amahi Home Server
# Copyright (C) 2007-2013 Amahi
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License v3
# (29 June 2007), as published in the COPYING file.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# file COPYING for more details.
#
# You should have received a copy of the GNU General Public
# License along with this program; if not, write to the Amahi
# team at http://www.amahi.org/ under "Contact Us."

require 'command'
require 'platform'


class WebappAccess < ActiveRecord::Base

attr_accessible :webapp_id, :access_to
belongs_to :webapps


	def getUsers
		user_ids = JSON.parse(self.access_to)
		@users_allowed = []
		user_ids.each do |user_id|
			user = User.where(:id=>user_id).first
			@users_allowed << user if user
		end
		@users_allowed
	end

	def remove_all_users
		self.access_to = [].to_s
		self.save!
	end

	def addUser(user,password)
		users = JSON.parse(self.access_to)
		if(!users.include?(user.id))
			users = users << user.id
		end
		self.access_to = users.to_s
		self.save!
		webapp = Webapp.find(self.webapp_id)
		path = webapp.path
		htpasswd_path = path+'/htpasswd'
		if(File.file?(htpasswd_path))
			c = Command.new "htpasswd -bm #{htpasswd_path} #{user.login} #{password}"
		else
			c = Command.new "htpasswd -cbm #{htpasswd_path} #{user.login} #{password}"
		end
			c.execute
		Platform.reload(:apache)
	end

	def removeUser(user)
		users = JSON.parse(self.access_to)
		if(users.include?(user.id))
			users.delete(user.id)
		end
		self.access_to = users.to_s
		self.save!
		webapp = Webapp.find(self.webapp_id)
		path = webapp.path
		htpasswd_path = path+'/htpasswd'
		if(File.file?(htpasswd_path))
			c = Command.new "htpasswd -D #{htpasswd_path} #{user.login}"
			c.execute
		end
		Platform.reload(:apache)

	end

	def self.find_or_create(webapp_id)
		webapp_access = WebappAccess.where(:webapp_id=>webapp_id).first
		if(webapp_access == nil)
			webapp_access = WebappAccess.create(:webapp_id=>webapp_id,:access_to=>[].to_s)
		end
		webapp_access
	end
end