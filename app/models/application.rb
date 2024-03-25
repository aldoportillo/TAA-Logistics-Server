class Application < ApplicationRecord
    after_create :send_new_application_email

    def self.ransackable_attributes(auth_object = nil)
      %w(first_name last_name)
    end
  
    # Define which associations can be searched through Ransack
    def self.ransackable_associations(auth_object = nil)
      # List any associations you want to be searchable, if any
      []
    end

    private

    def send_new_application_email
        ApplicationsMailer.new_application_email(self).deliver_later
    end
  end
  