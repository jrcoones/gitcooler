class ApiController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  rescue_from Exception, :with => :unhandled_exception
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  private
  def record_not_found(exception)
    id = params[:id]
    class_name = self.class.name
    human_class_name = self.class.name.underscore.humanize.downcase
    message = t('api.errors.record_not_found', column_name: id, class_name: human_class_name, :action_name => action_name)

    @exception = {
      id: id,
      class_name: class_name,
      action_name: action_name,
      message: message
    }

    render "layouts/errors/record_not_found", :status => 404
  end

  def unhandled_exception(exception)
    render "layouts/errors/unhandled_exception", :status => 500
  end
end
