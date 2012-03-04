class GitCooler.Routers.Projects extends Backbone.Router
  routes:
    '': 'index'
    'projects/:id': 'show'

  initialize: ->
    @collection = new GitCooler.Collections.Projects(gon.projects)
    @collection.fetch()

  index: ->
    view = new GitCooler.Views.ProjectsIndex(collection: @collection)
    $('#container').html(view.render().el)

  show: (id) ->
    model = @collection.get(id)
    view = new GitCooler.Views.ProjectsShow(model: model)
    $('#container').html(view.render().el)
