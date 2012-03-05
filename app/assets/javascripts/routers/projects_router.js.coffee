class GitCooler.Routers.Projects extends Backbone.Router
  baseContainer: '#content'

  routes:
    '': 'index'
    'projects': 'index'
    'projects/:id': 'show'

  initialize: ->
    @collection = new GitCooler.Collections.Projects(gon.projects)
    @collection.fetch()

  index: ->
    @projectListSideBar()

  show: (id) ->
    @projectListSideBar()
    view = new GitCooler.Views.ProjectsShow(model: @collection.get(id))
    $(@baseContainer).html(view.render().el)

  projectListSideBar: ->
    view = new GitCooler.Views.ProjectsList(collection: @collection)
    $('#project-list').html(view.render().el)
