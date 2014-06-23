class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  after_action :set_access_control_headers
def handle_options_request
    head(:ok) if request.request_method == "OPTIONS"
end

  def set_access_control_headers
    # headers['Access-Control-Allow-Origin'] = '*'
    # headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE'
    headers['Access-Control-Allow-Origin'] = '*' 
    headers['Access-Control-Request-Method'] = '*'
  end
  protected

  def stored_location_for(resource)
    nil
  end

  def admin_or_client_only
    if current_user.admin? || current_user.client?
    else
      return redirect_to root_path 
    end
  end
end
