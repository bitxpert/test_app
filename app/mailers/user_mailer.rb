class UserMailer < ActionMailer::Base
  default from: "testdevsinc@gmail.com"

  def invitation(email)
    mail(:to => email, :subject => "invitation")
  end
end
