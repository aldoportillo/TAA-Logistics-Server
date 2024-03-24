class Inquiry < ApplicationRecord
    after_create :send_new_inquiry_email

    private

    def send_new_inquiry_email
        InquiryMailer.new_inquiry_email(self).deliver_later
    end
end
