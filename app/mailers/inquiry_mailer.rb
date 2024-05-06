class InquiryMailer < ApplicationMailer
    default from: ENV[MAILER_EMAIL]
  
    def new_inquiry_email(inquiry)
      @inquiry = inquiry
      mail(to: ENV[MAILER_EMAIL], subject: 'New inquiry Received')
    end
end
