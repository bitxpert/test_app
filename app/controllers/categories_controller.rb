class CategoriesController < ApplicationController
	respond_to :html, :json, only: [:index,:questions,:question]
	def index
		choice = Choice.where(checklist_id: params[:report]).first
		# @status = ''
		if choice.present?
			@category = Category.where(id: choice.category_id)
			# @status = false
		else
			@category = Category.all
			# @status = true
			# respond_with @category
		end
		respond_with :obj => { category: @category}
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

		# cats = Category.where.not(id: @category.id)
		# # cats.each do |c|
		# 	cats.first.questions.each do |q|
		# 		q.answers.first.destroy if  q.answers.first.present?
		# 	end
		# # end

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

	def noquestions
		@category = Category.find(params[:id])
		@question = @category.questions.first
		choice = Choice.where(checklist_id: params[:report]).first
		@answer = Answer.where(report_id: params[:report], question_id: @question.id).first
		return render :json=> @answer
	end
end
