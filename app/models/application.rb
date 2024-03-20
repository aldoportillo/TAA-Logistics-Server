class Application < ApplicationRecord
    # Define your associations and other model details here
  
    # Define which attributes can be searched through Ransack
    def self.ransackable_attributes(auth_object = nil)
      %w(first_name last_name)
    end
  
    # Define which associations can be searched through Ransack
    def self.ransackable_associations(auth_object = nil)
      # List any associations you want to be searchable, if any
      []
    end
  end
  