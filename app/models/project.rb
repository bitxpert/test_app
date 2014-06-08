class Project < ActiveRecord::Base
	belongs_to :creator, class_name: "User"
	belongs_to :user
	has_many :answers, dependent: :destroy
	has_many :incidents, dependent: :destroy
	
	validates_presence_of :address
	validates_presence_of :contact_info

	after_create :create_answers
  	def create_answers
	    Question.all.each do |q|
	      self.answers.create!(question_id: q.id)
	    end
  	end
end
