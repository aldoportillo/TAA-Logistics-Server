class CreateQuotes < ActiveRecord::Migration[7.1]
  def change
    create_table :quotes do |t|
      t.string :company_name
      t.string :contact_name
      t.string :email
      t.string :phone
      t.string :fax
      t.string :commodity
      t.integer :commodity_temp
      t.integer :commodity_gross_weight
      t.string :from
      t.date :delivery_date
      t.string :delivery_zip_code
      t.date :shipping_date
      t.string :shipping_zip_code
      t.integer :CS
      t.string :container_size
      t.integer :pallets
      t.string :equipment_type
      t.string :rail_destination
      t.string :questions_or_notes

      t.timestamps
    end
  end
end
