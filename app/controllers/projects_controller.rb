class ProjectsController < ApiController
  def index
    respond_with Project.all
  end
end
