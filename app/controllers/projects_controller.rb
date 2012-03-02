class ProjectsController < ApiController
  def index
    @projects = current_user.my_projects
    respond_with @projects
  end

  def show
    @project = current_user.my_projects.find params[:id]
    respond_with @project
  end

  def update
    @project = current_user.my_projects.find params[:id]
    @project.update_attributes params[:project]
    respond_with @project
  end

  def create
    @project = Project.create! params[:project].merge({ owner_id: current_user.id })
    respond_with @project
  end

  def destroy
    @project = current_user.my_projects.find params[:id]
    @project.destroy
  end
end
