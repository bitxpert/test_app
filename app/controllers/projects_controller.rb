class ProjectsController < ApplicationController	
	before_action :authenticate_user!
	before_action :check_user
	before_action :set_project, only: [:show, :edit, :update, :destroy, :detail_report]
	respond_to :html, :json, only: [:index, :new, :create, :edit, :update, :show, :destroy,:assign_project,:add_users,:reports]
	
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
			if current_user.role == "client"
				users = params[:project][:userid] if params[:project][:userid].present?
				users && users.each do |user|
					if user != ""
						project_user = ProjectsUsers.new
						project_user.user_id = user.to_i
						project_user.project_id = @project.id
						project_user.save!

						report = @project.reports.build
				  		report.name = "#{@project.name} Report #{Date.today.to_s}"
				  		report.user_id = user.to_i
				  		report.save!
					    Question.all.each do |q|
					      Answer.create!(question_id: q.id, report_id: report.id, file: nil)		
						end
					end	
				end
			end
			# if current_user.role == "user"
				# report = Report.find_by_user_id(current_user.id)
				report = Report.where(user_id: current_user.id, project_id: @project.id).first
				if !report.present?
					report = @project.reports.build
			  		report.name = "#{@project.name} Report #{Date.today.to_s}"
			  		report.user_id = current_user.id
			  		report.save!
				    Question.all.each do |q|
				      Answer.create!(question_id: q.id, report_id: report.id, file: nil)		
					end
				end
				# project_user = ProjectsUsers.find_by_user_id(current_user.id) || ProjectsUsers.new
				project_user = ProjectsUsers.where(user_id:current_user.id, project_id: @project.id).first || ProjectsUsers.new
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

	def report
		@project = Project.find(params[:id])
		user = User.find(ProjectsUsers.find_by_project_id(@project.id).user_id)
		@uname = user.first_name || user.last_name
		@days_30 = @project.reports.where("created_at >= ?", Date.today-30.days).count
		@days_60 = @project.reports.where("created_at >= ?", Date.today-60.days).count
		@days_90 = @project.reports.where("created_at >= ?", Date.today-90.days).count
		
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
    		format.json {render :json=> true}
    		format.pdf do
      		pdf = ProjectDetailPdf.new(@project, view_context)
      		send_data pdf.render, filename: "(#{@project.name}) project report.pdf", type: "application/pdf", disposition: "attachment"
    		end
 		end
	end

	def assign_project
		@project = Project.find(params[:id])
		respond_with @project
	end


	def add_users
		
		id = params[:projectid]
		users = params[:project][:userid] if params[:project][:userid].present?
		project = Project.find(id)
		users && users.each do |user|
			if user != ""
				project_user =  ProjectsUsers.where(user_id: user , project_id: id).first || ProjectsUsers.new
				project_user.user_id = user.to_i
				project_user.project_id = id.to_i
				project_user.save!	
				report = Report.find_by_user_id(user.to_i)
				if !report.present?
					report = project.reports.build
			  		report.name = "#{project.name} Report #{Date.today.to_s}"
			  		report.user_id = user.to_i
			  		report.save!
				    Question.all.each do |q|
				      Answer.create!(question_id: q.id, report_id: report.id, file: nil)		
					end
				end	
			end	
		end
		# respond_with project_user
		respond_to do |format|
	        format.html { redirect_to projects_path, notice: 'Users add successfully.' }
	        format.json { render :json=> true }
	    end
		# flash[:success] = "Users add successfully"
		# redirect_to projects_path		
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
