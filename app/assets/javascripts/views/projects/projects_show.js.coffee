class GitCooler.Views.ProjectsShow extends Backbone.View

  template: JST['projects/show']

  initialize: ->
    @model.on('change', @render, this) if @model

  render: ->
    $(@el).html(@template(project: @model))
    this
