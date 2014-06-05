class ProjectsController < ApplicationController

	before_filter :require_login 
	before_filter :check_user_projects_limit  ,:except => [:allmyprojects, :index, :show, :edit, :update]

	def allmyprojects
		@project = current_user.projects	
	end
	
	def index
		@projects = Project.find(:all)	
	end	

	def new 
		@project = current_user.projects.build 
	end

	def create
		if current_user.projects.create params_project
			flash[:notice] = "Project successfully created"
			redirect_to root_url 
		else 
			render :new
		end
	end	

	
	def show 
		@project = Project.find(params[:id])
	end	

	
	def params_project
		params.require(:project).permit(:name,:contact_info,:address)
	end

	def check_user_projects_limit
		if current_user.user_type != "manager"
			if ProjectUser.find_by_user_id(current_user).present?
				flash[:notice] = "you have exceeded the project limit"
				redirect_to root_url 
		 	end
		 end
	end

	def myproject
		@user = current_user
		@project_user = @user.project_users.create!(project_id: params[:id])
		flash[:notice] = "successful [developers and QA] can have only one project"
		redirect_to root_url 
	end

	def edit
		@project = Project.find(params[:id])
	end

	def update
		@project = Project.find(params[:id])
	    if @project.update(params_project)
	    	flash[:notice] = "Project successfuly updated"
	    else
	    	flash[:error] = "something going wrong"	
	    end
	    redirect_to root_path
	end
end
