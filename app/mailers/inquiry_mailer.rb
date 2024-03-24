class InquiryMailer < ApplicationMailer
    default from: 'notifications@example.com'
  
    def new_inquiry_email(inquiry)
      @inquiry = inquiry
      mail(to: 'aldoportillodev@gmail.com', subject: 'New inquiry Received')
    end
end
