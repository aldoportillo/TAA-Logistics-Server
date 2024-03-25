class AddContactedToApplications < ActiveRecord::Migration[7.1]
  def change
    add_column :applications, :contacted, :boolean
  end
end
