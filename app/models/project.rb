class Project < ActiveRecord::Base
	belongs_to :user
	validates_presence_of :contact_info
	validates_presence_of :address
end
