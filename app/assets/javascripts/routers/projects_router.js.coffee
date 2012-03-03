class GitCooler.Routers.Projects extends Backbone.Router
  routes:
    '': 'index'
    'projects/:id': 'show'

  initialize: ->
    @collection = new GitCooler.Collections.Projects()
    @collection.fetch()

  index: ->
    view = new GitCooler.Views.ProjectsIndex(collection: @collection)
    $('#container').html(view.render().el)

  show: (id) ->
    alert "you are trying to show #{id}"
