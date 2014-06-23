class SessionsController < Devise::SessionsController
  prepend_before_filter :require_no_authentication, :only => [:create, :new ]
  
  # before_filter :ensure_params_exist, only: [:create]
 
  respond_to :json, :html
  def create
    if request.method == "OPTIONS"
      headers['Access-Control-Allow-Origin'] = request.env['HTTP_ORIGIN']
      headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
      headers['Access-Control-Max-Age'] = '1000'
      headers['Access-Control-Allow-Headers'] = '*,x-requested-with'
      
      return (head :ok)
    end
    
    resource = User.find_for_database_authentication(:email=>params[:user][:email])
    return invalid_login_attempt unless resource
 
    if resource.valid_password?(params[:user][:password])
      sign_in("user", resource)
		respond_to do |format|
	        format.html { redirect_to root_path}
	        format.json { render :json=> resource }
	    end
      return
    end
    invalid_login_attempt
  end
  
  def destroy
    sign_out(resource_name)
    respond_to do |format|
	        format.html { redirect_to root_path}
	        format.json { render :json=> resource }
	    end
    
  end
 
  protected
  def ensure_params_exist
    return unless params[:user].blank?
	respond_with resource, status: 404
  end
 
  def invalid_login_attempt
    warden.custom_failure!
    render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
  end
end
