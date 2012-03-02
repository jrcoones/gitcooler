class ProjectsController < ApiController
  def index
    @projects = current_user.my_projects
  end

  def show
    @project = current_user.my_projects.find params[:id]
  end
end
