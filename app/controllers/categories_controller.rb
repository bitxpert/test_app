class CategoriesController < ApplicationController
	respond_to :html, :json, only: [:index]
	def index
		@category = Category.all
		respond_with @category
	end
end
