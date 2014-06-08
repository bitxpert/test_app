class AnswersController < ApplicationController

	before_action :set_project_and_answer
	respond_to :html, :json
	def update
		if @answer.update(status: params[:status])
			respond_with @answer
		else
			respond_with false
		end
	end
	private
	def set_project_and_answer
		@project = current_user.whole_projects.find(params[:project_id])
		@answer = @project.answers.find(params[:id])

	end

end
