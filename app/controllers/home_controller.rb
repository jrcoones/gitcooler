class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    @projects = current_user.my_projects
    gon.rabl 'app/views/projects/index.json.rabl', :as => 'projects'
  end
end
