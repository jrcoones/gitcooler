window.GitCooler =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    new GitCooler.Routers.Projects()
    Backbone.history.start()

$(document).ready ->
  GitCooler.init()
