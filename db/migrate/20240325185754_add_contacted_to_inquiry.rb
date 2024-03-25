class AddContactedToInquiry < ActiveRecord::Migration[7.1]
  def change
    add_column :inquiries, :contacted, :boolean
  end
end
