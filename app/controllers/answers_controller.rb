class AnswersController < ApplicationController

	before_action :set_project_and_answer, only: [:update]
	respond_to :html, :json
	def update
		if @answer.update(status: params[:status])
			respond_with @answer
		else
			respond_with false
		end
	end

	def update_answer
		answer = Answer.find(params[:id])
		# puts "---0"*90
		# puts answer.inspect
		answer.notes = params[:answer][:notes]
		answer.file = params[:answer][:file]
		answer.save!
		return render :json=> true
	end
	private
	def set_project_and_answer
		@report = Report.find(params[:report])
		# @project = current_user.whole_projects.find(params[:project_id])
		@answer = @report.answers.find(params[:id])
	end

end
