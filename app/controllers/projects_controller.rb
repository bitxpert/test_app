class ProjectsController < ApplicationController	
	before_action :authenticate_user!
	before_action :check_user
	before_action :set_project, only: [:show, :edit, :update, :destroy, :detail_report]
	respond_to :html, :json, only: [:index, :new, :create, :edit, :update, :show, :destroy]
	
	def index
		@projects = current_user.whole_projects
		respond_with @projects	
	end	

	def new 
		@project = Project.new
		respond_with @project
	end

	def create
		user_client = current_user.client
		params[:project][:creator_id] = current_user.id 
		@project = user_client.projects.build(params_project)
		if @project.save
		flash[:notice] = "Project was successfully created." 
		end
		respond_with @project
	end	

	def show
		@categories = Category.all.includes(:questions)
		@answers = @project.reports.first.answers
		respond_with :obj => {project: @project, categories: @categories, answers: @answers}
	end	

	def edit
		respond_with @project
	end

	def update
    	flash[:notice] = 'Project was successfully updated.' if @project.update(params_project)
    	respond_with @project	
	end

	def destroy
    	respond_with @project.destroy
	end	

	def detail_report
  		respond_to do |format|
    		format.html
    		format.json
    		format.pdf do
      		pdf = ProjectDetailPdf.new(@project, view_context)
      		send_data pdf.render, filename: "(#{@project.name}) project report.pdf", type: "application/pdf", disposition: "attachment"
    		end
 		end
	end


	# def reports
	# 	@project = Project.find(params[:id])
	# 	@reports = @project.reports
	# end

	private

	def params_project
		params.require(:project).permit(:name, :contact_info, :address, :user_id, :creator_id)
	end

	def check_user
		if current_user.role == 'admin'
			flash[:notice] = 'You are not Authorise'
			return redirect_to root_url
		end	
	end	

	def set_project
		@project = current_user.whole_projects.find(params[:id])
	end
end
