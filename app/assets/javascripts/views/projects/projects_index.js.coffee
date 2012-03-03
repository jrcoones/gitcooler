class GitCooler.Views.ProjectsIndex extends Backbone.View

  template: JST['projects/index']

  events:
    'submit #new-project': 'createProject'

  initialize: ->
    @collection.on('reset', @render, this)
    @collection.on('add', @render, this)

  render: ->
    $(@el).html(@template(projects: @collection))
    this

  createProject: (event) ->
    event.preventDefault()
    attributes =
      title: $('#new-project-title').val()
      description: $('#new-project-description').val()

    @collection.create attributes,
      wait: true
      success: @handleSuccess
      error: @handleError

  handleSuccess: ->
    $('#new-project')[0].reset()

  handleError: (project, response) ->
    if response.status == 422
      errors = $.parseJSON(response.responseText).error.errors
      for attribute, error of errors
        alert "#{attribute} #{message}" for message in error
