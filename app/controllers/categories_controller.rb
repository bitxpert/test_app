class CategoriesController < ApplicationController
	respond_to :html, :json, only: [:index,:questions,:question]
	def index
		@category = Category.all
		respond_with @category
	end

	def answers
		@report = Report.find(params[:report_id])
		@category = Category.find(params[:id])
	end

	def questions
		@category = Category.find(params[:id])
		@questions = @category.questions
		respond_with @questions
	end

	def question
		@category = Category.find(params[:id])
		@question = @category.questions.first
		@answer = Answer.where(question_id: @question.id, report_id: params[:report]).first
	end
end
