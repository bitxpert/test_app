class Answer < ActiveRecord::Base

	belongs_to :question
	# belongs_to :project
	belongs_to :report

end
