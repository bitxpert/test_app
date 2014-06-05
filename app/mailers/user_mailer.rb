class UserMailer < ActionMailer::Base
  default from: "testdevsinc@gmail.com"

  def invitation(email,token,baseurl)
  	@token = token
  	@base_url = baseurl
    mail(:to => email, :subject => "invitation")


  end
end
