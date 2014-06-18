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
		
		# @project.user_id = current_user.id

		# @project = user_client.build_projects(params_project)
		if @project.save
			report = @project.reports.first 
			report.name = "#{@project.name} Report #{Date.today.to_s}"
			report.save!
			if current_user.role == "client"
				users = params[:project][:userid] if params[:project][:userid].present?
				users && users.each do |user|
					if user != ""
						project_user = ProjectsUsers.new
						project_user.user_id = user.to_i
						project_user.project_id = @project.id
						project_user.save!		
					end	
				end
			end
			# if current_user.role == "user"
				project_user = ProjectsUsers.new
				project_user.user_id = current_user.id
				project_user.project_id = @project.id
				project_user.save!
			# end
		flash[:notice] = "Project was successfully created." 
		end
		respond_with @project
	end	

	def update_answer
		answer = Answer.find(params[:id])
		puts "---0"*90
		puts answer.inspect
		answer.notes = params[:answer][:notes]
		answer.file = params[:answer][:file]
		answer.save!
		return render :json=> true
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

	def assign_project
		@project = Project.find(params[:id])
	end


	def add_users
		puts "--"*90
		puts params
		id = params[:projectid]
		users = params[:project][:userid] if params[:project][:userid].present?
		users && users.each do |user|
			if user != ""
				project_user =  ProjectsUsers.where(user_id: user , project_id: id).first || ProjectsUsers.new
				project_user.user_id = user.to_i
				project_user.project_id = id.to_i
				project_user.save!		
			end	
		end
		flash[:success] = "Users add successfully"
		redirect_to projects_path		
	end

	private

	def params_project
		params.require(:project).permit(:name, :contact_info, :address, :user_id, :creator_id, :userid)
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
