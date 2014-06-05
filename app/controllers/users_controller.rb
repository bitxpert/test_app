class UsersController < ApplicationController

	def index
		
	end	

	def new
  		@user = User.new
	end

	def create
  		@user = User.create(user_params)
  		if @user.save
    	flash[:notice] = "Thankyou for signing up!"
    	redirect_to root_url
  		else
    	render :new
  		end
	end	

	private
  	def user_params
    	params.require(:user).permit(:email, :password, :password_confirmation, :user_type, :name)
  	end
end
