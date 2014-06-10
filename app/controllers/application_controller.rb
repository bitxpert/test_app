class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

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
