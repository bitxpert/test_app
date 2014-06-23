class ReportsController < ApplicationController
	respond_to :html, :json
	def index
		@project = Project.find(params[:project_id])
		@reports = @project.reports
		respond_with :obj => {:@project=> @project,:@reports=>@reports }
	end

	def destroy
		report = Report.find(params[:id])
		report.destroy
		@project = Project.find(params[:project_id])
		respond_to do |format|
	        format.html { redirect_to project_reports_path(@project), success: 'Users add successfully.' }
	        format.json { render :json=> true }
	    end
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
    		format.json { render :json=> true} 
    		format.pdf do
      		pdf = ReportDetailPdf.new(@report, view_context)
      		send_data pdf.render, filename: "(#{@report.name}) report.pdf", type: "application/pdf", disposition: "attachment"
    		end
 		end
	end
end
