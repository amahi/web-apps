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
	if results.status is "ok"
  		$('#webapps-table').parent().html(results.content)


$(document).on "ajax:success", ".delete_webapp", (event, results) ->
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



