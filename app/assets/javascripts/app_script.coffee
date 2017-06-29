$(document).on "turbolinks:load", ->
  title = $(document).attr("title")
  id = "#active-" + title.substring(0, title.indexOf("|") - 1).toLowerCase()
  $(id).addClass "active"
