class UserMailer < ActionMailer::Base
  # default from: "faisalbhatti.pucit@gmail.com"

  def invitation(email,token,baseurl)
  	@email = email
  	@token = token
  	@base_url = baseurl
    mail(:to => email, :subject => "invitation")
  end

  def send_incident_report(user,body,pname,cname,answer,to)
  	@answer = answer
  	@file = answer.file_url
  	@email = to
    @user = user
    @cname = cname
    @body = body
  	mail(:from=>user.email,:to => to, :subject => pname)
  end

end
