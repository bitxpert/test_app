class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates_presence_of :first_name       



  has_many :invitations 
  has_many :projects
  has_many :created_projects, class_name: "Project", foreign_key: "creator_id"
  has_many :subordinates, class_name: "User", foreign_key: "client_id"
  belongs_to :client, class_name: "User"

  def whole_projects
  	self.client.projects || self.projects
  end
  def admin?
    self.role == "admin"
  end
  def client?
    self.role == "client"
  end
  # def password
  #   key = "helloworld123"
  #   encrypted_data = read_attribute(:password)
  #   AESCrypt.decrypt(encrypted_data, key)
  # end

  # def password=(pwd)
  #   key = "helloworld123"
  #   encrypted_data = AESCrypt.encrypt(pwd, key)
  #   write_attribute(:password, encrypted_data)
  # end
end
