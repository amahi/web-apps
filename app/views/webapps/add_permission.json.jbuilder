self.formats = [:html]
	json.status @status
	json.type :permission
	json.webappid @webapp.id
	json.userid @user.id
	json.content render(:partial => 'user_permissions')
