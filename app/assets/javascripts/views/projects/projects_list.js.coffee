class GitCooler.Views.ProjectsList extends Backbone.View
  tagName: 'ul'

  className: 'nav nav-list'

  template: JST['projects/list']

  initialize: ->
    @collection.on('reset', @render, this)
    @collection.on('add', @render, this)

  render: ->
    $(@el).html(@template(projects: @collection))
    this
