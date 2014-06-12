self.formats = [:html]

  json.status :ok
  json.type :path
  json.id @webapp.id
  json.content render(:partial => "path", :object => @webapp)
