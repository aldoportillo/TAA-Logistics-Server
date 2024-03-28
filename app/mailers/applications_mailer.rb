class ApplicationsMailer < ApplicationMailer
  default from: 'ed@taalogistics.com'

  def new_application_email(application)
    @application = application
    mail(to: 'ed@taalogistics.com', subject: 'New application Received')
  end

end
