class CreateInquiries < ActiveRecord::Migration[7.1]
  def change
    create_table :inquiries do |t|
      t.string :name
      t.string :phone_number
      t.string :email_address
      t.text :message

      t.timestamps
    end
  end
end
