class UserMailer < ActionMailer::Base
  default from: "testdevsinc@gmail.com"

  def invitation(email,token,baseurl)
  	@email = email
  	@token = token
  	@base_url = baseurl
    mail(:to => email, :subject => "invitation")
  end

  def send_incident_report(user,incident)
  	@id = incident.id
  	@file = incident.file_url
  	@email = user.email
  	mail(:to => user.email, :subject => "Incident Report")
  end

end
