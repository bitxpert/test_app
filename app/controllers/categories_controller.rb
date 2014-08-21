class CategoriesController < ApplicationController
	respond_to :html, :json, only: [:index,:questions,:question]
	def index
		choice = Choice.where(checklist_id: params[:report]).first
		status = ''
		if choice.present?
			@category = Category.find(choice.category_id)
			status = false
		else
			@category = Category.all
			status = true
			# respond_with @category
		end
		respond_with :obj => { category: @category,  status: status}
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
		@status = false
		@category = Category.find(params[:id])
		@question = @category.questions.first
		choice = Choice.where(checklist_id: params[:report]).first
		if !choice.present?
			choice = Choice.new
			choice.checklist_id = params[:report]
			choice.category_id = @category.id
			choice.save!
		else
			@status = true
		end
		@answer = Answer.where(question_id: @question.id, report_id: params[:report]).first
	end
end
