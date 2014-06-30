class QuestionsController < ApplicationController
	respond_to :html, :json, only: [:index]
	def index
		@questions = Question.all
		respond_with @questions
	end
end
