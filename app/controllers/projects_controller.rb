class ProjectsController < ApplicationController	
	before_action :authenticate_user!
	before_filter :check_user
	respond_to :html, :json
	
	def index
		@projects = Project.where(:user_id => current_user.refrer)
		respond_with @projects	
	end	

	def new 
		@project = Project.new
		respond_with @project
	end

	def create
		params[:project][:user_id] = current_user.refrer
		params[:project][:creator] = current_user.id 
		@project = Project.new(params_project)
		if @project.save
		flash[:notice] = "Project was successfully created." 
		end
		respond_with @project
	end	

	def show 
		@project = Project.find(params[:id])
		respond_with @project
	end	

	def edit
		@project = Project.find(params[:id])
		respond_with @project
	end

	def update
		@project = Project.find(params[:id])
    	flash[:notice] = 'Project was successfully updated.' if @project.update(params_project)
    	respond_with @project	
	end

	def destroy
		@project = Project.find(params[:id])
    	respond_with @project.destroy
	end	

	private

	def params_project
		params.require(:project).permit(:name, :contact_info, :address, :user_id, :creator)
	end

	def check_user
		if current_user.role == 'admin'
			flash[:notice] = 'You are not Authorise'
			return redirect_to root_url
		end	
	end	
end
