class ProjectsController < ApiController
  def index
    @projects = current_user.my_projects
    respond_with @projects
  end

  def show
    @project = current_user.my_projects.find params[:id]
    respond_with @project
  end
end
