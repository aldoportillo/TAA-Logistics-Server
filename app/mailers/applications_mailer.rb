class ApplicationsMailer < ApplicationMailer
  default from: ENV['MAILER_EMAIL']

  def new_application_email(application)
    @application = application
    mail(to: ENV['MAILER_EMAIL'], subject: 'New application Received')
  end

end
