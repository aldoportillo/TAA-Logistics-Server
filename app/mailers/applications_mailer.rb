class ApplicationsMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def new_application_email(application)
    @application = application
    mail(to: 'aldoportillodev@gmail.com', subject: 'New application Received')
  end

end
