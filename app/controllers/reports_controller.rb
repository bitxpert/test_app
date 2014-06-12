class ReportsController < ApplicationController
	
	def index
		@project = Project.find(params[:project_id])
		@reports = @project.reports
	end

	def destroy
		report = Report.find(params[:id])
		report.destroy
		@project = Project.find(params[:project_id])
		flash[:success] = "Report has been successfully destroyed."
		redirect_to reports_project_path(@project)
	end

	def show
		@report = Report.find(params[:id])
		@project = @report.project
		@categories = Category.all.includes(:questions)
		@answers = @report.answers
		# respond_with :obj => {project: @project, categories: @categories, answers: @answers}
	end

	def detail_report
		@report = Report.find(params[:id])
  		respond_to do |format|
    		format.html
    		format.json
    		format.pdf do
      		pdf = ReportDetailPdf.new(@report, view_context)
      		send_data pdf.render, filename: "(#{@report.name}) report.pdf", type: "application/pdf", disposition: "attachment"
    		end
 		end
	end
end
