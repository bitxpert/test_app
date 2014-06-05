 class RegistrationsController  < Devise::RegistrationsController
  #before_filter :token_verification_of_referal

  def create
    # sign_up_params.permit(:first_name, :last_name)
    #return render json: sign_up_params
    if Invitation.find_by_auth_token(allow_token[:auth_token]).present? 
    build_resource(sign_up_params)

    if resource.save
      yield resource if block_given?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
    else
      flash[:error] = "Authentication tokken mismatch"
      redirect_to root_path
  end
  end
 
private
  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role)
  end
  def allow_token
      params.require(:user).permit(:auth_token)
      
  end
  def token_verification_of_referal
    
    
    if Invitation.find_by_auth_token(params[:auth_token]).present?
      create
    else
      flash[:error] = "Authentication tokken mismatch"
      redirect_to root_path
    end  
  end  

end