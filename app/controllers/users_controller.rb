class UsersController < ApplicationController
	before_action :authenticate_user!
	before_filter :admin_or_client_only, only: [:new, :create, :destroy, :index]
	before_filter :find_user, only: [:edit, :destroy]
	
	def new
		@user = User.new
		if current_user.admin?
			@role = "client"  
		else
			@role = "user"
			@client_id = current_user
		end
	end
	def create
		    params.permit!
		    puts "---"*90
		@user = User.new(params[:user])
		if @user.save
			if current_user.admin?
				@user.role = "client"  
			else
				@user.role = "user"
				@user.client_id = current_user.id
			end
			@user.save!
			if @user.role == "client"
				id = @user.id
				@user.client_id = id
				@user.save!
			end
			flash[:notice] = "User has been added successfully."
			return redirect_to users_path
		else
			return render "new"
		end
	end
	def index

		if current_user.admin?
			@users = User.all
		else
			@users = current_user.subordinates
		end
	end	

	def destroy
		user = User.find(params[:id])
		user.destroy if user.present?
		flash[:success] = "successfully destroyed."
		redirect_to users_path
	end
	def edit
		return redirect_to root_path if !current_user.admin? && current_user.id.to_s != params[:id]
		@user = User.find(params[:id])
	end
	

	private
	def find_user
		@user = User.find(params[:id])
	end
  	def user_params
    	params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name)
  	end
end
