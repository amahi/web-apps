#edit entry
$(document).ready ->
	$(document).on "click", ".click_change", ->
	  $(this).hide()
	  $(this).parent().find(".edit_form").show()

	$(document).on "click", ".cancel_link",->
	  parent = $(this).parents('.edit_form')[0]
	  $(parent).hide()
	  superparent = $(parent).parents('td')[0]
	  element = $(superparent).find('.click_change')
	  element.show()

#new webapp
$(document).on "ajax:success", "#webapp-new", (event, results) ->
	console.log(results)
	if results.status is "ok"
  		$('#webapps-table').parent().html(results.content)


$(document).on "ajax:success", ".delete_webapp", (event, results) ->
	console.log(results)
	if results.status is "ok"
		$('#webapps-table').parent().html(results.content)

$(document).on "ajax:success", ".edit_form", (event, results) ->
	console.log(results)
	if results.status is "ok"
		if results.type is "aliases"
			element = "#webapp_aliases_"+results.id
			$(element).parent().html(results.content)
		else if  results.type is "name"
			element = "#webapp_name_"+results.id
			$(element).html(results.content)
		else if results.type is "path"
			element = "#webapp_path_"+results.id
			$(element).html(results.content)
		else if results.type is "permission"
			element = "#permission_webapp"+results.webappid+"_user"+results.userid
			$(element).html(results.content)
	else if results.type is "permission"
		element = "#permission_webapp"+results.webappid+"_user"+results.userid
		$(element).find('.messages').html(results.status)

$(document).on "ajax:beforeSend", ".edit_form", ->
	form = $(this)
	form.find(".spinner").show "fast"
	form.find("button, input[type=submit]").hide()
	form.find("a.cancel_link").hide()

$(document).on "ajax:complete", ".edit_form", ->
	form = $(this)
	form.find(".spinner").hide()
	form.find("button, input[type=submit]").show()
	form.find("a.cancel_link").show()
$(document).on 'keyup', '#webapp_name', ->
  name = $(this).val()
  unless name.length is 0
  	path = "/var/hda/web-apps/"+name
  	$('#webapp_path').val(path)
  else
  	$('#webapp_path').val('')