self.formats = [:html]

  json.status :ok
  json.type :name
  json.id @webapp.id
  json.content render(:partial => "name", :object => @webapp)
