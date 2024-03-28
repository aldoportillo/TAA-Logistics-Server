class InquiryMailer < ApplicationMailer
    default from: 'ed@taalogistics.com'
  
    def new_inquiry_email(inquiry)
      @inquiry = inquiry
      mail(to: 'ed@taalogistics.com', subject: 'New inquiry Received')
    end
end
