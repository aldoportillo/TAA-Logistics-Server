class ApplicationsMailer < ApplicationMailer
  default from: 'aporti4@uillinois.edu'

  def new_application_email(application)
    @application = application
    mail(to: 'aporti4@uillinois.edu', subject: 'New application Received')
  end

end
