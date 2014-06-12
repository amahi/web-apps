self.formats = [:html]

  json.status :ok
  json.type :list
  json.content render(:partial => 'content', :object => @webapps)
