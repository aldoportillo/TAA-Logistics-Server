class Quote < ApplicationRecord
  after_create :send_new_quote_email

    def self.ransackable_attributes(auth_object = nil)
        %w(contact_name company_name)
      end
  
      def self.ransackable_associations(auth_object = nil)
        # List any associations you want to be searchable, if any
        []
      end

    private

    def send_new_quote_email
      QuoteMailer.new_quote_email(self).deliver_later
    end
end
