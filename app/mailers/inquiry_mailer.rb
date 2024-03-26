class InquiryMailer < ApplicationMailer
    default from: 'aporti4@uillinois.edu'
  
    def new_inquiry_email(inquiry)
      @inquiry = inquiry
      mail(to: 'aporti4@uillinois.edu', subject: 'New inquiry Received')
    end
end
