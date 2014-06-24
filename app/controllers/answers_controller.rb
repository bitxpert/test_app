class AnswersController < ApplicationController

	# before_action :set_project_and_answer, only: [:update]
	respond_to :html, :json
	def update

		@answer = Answer.find(params[:id])
		if @answer.update(status: params[:status])
			if params[:note].present?
				@answer.notes = params[:note]
				@answer.save!
			end 
			respond_with true
		else
			respond_with false
		end
	end

	def check_answer
		answer = Answer.find(params[:id])
		if answer.status == 2
			return render :json=> true
		else
			return render :json=> false
		end
	end


	def update_answer
		answer = Answer.find(params[:id])
		
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
