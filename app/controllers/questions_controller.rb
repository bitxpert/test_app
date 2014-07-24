class QuestionsController < ApplicationController
	respond_to :html, :json, only: [:index]
	def index
		@questions = Question.all
		respond_with @questions
	end
	
	def get_question
		question = Question.find(params[:id])
		return render json: question
	end
end
