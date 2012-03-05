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
    @setActive()
    view = new GitCooler.Views.ProjectsIndex(collection: @collection)
    $(@baseContainer).html(view.render().el)

  show: (id) ->
    @setActive()
    model = @collection.get(id)
    view = new GitCooler.Views.ProjectsShow(model: model)
    $(@baseContainer).html(view.render().el)

  setActive: ->
    _.each($('ul.nav li'), (element) ->
      $(element).removeClass('active'))
    $('li[data-router="projects"]').addClass('active')
