class Quote < ApplicationRecord

    def self.ransackable_attributes(auth_object = nil)
        %w(contact_name company_name)
      end
  
      def self.ransackable_associations(auth_object = nil)
        # List any associations you want to be searchable, if any
        []
      end
end
