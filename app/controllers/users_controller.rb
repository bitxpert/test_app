class UsersController < ApplicationController

	def index
	end	

	def destroy
		user = User.find(params[:id])
		user.destroy if user.present?
		flash[:success] = "successfully destroyed."
		redirect_to invitations_path
	end
	

	private
  	def user_params
    	params.require(:user).permit(:email, :password, :password_confirmation, :user_type, :name)
  	end
end
