self.formats = [:html]

  json.status :ok
  json.type :aliases
  json.id @webapp.id
  json.content render(:partial => "webapp_aliases", :object => @webapp)
