self.formats = [:html]

  json.status :ok
  json.type :replace_content
  json.content render(:partial => 'content', :object => @webapps)
