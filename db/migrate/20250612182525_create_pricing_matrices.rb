class CreatePricingMatrices < ActiveRecord::Migration[7.1]
  def change
    create_table :pricing_matrices do |t|
      t.integer :start_miles
      t.integer :end_miles
      t.decimal :price, precision: 10, scale: 2

      t.timestamps
    end
  end
end
