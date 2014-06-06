class UsersController < ApplicationController

	def index
	end	

	private
  	def user_params
    	params.require(:user).permit(:email, :password, :password_confirmation, :user_type, :name)
  	end
end
