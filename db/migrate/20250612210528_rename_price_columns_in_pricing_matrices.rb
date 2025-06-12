class RenamePriceColumnsInPricingMatrices < ActiveRecord::Migration[7.1]
  def change
    rename_column :pricing_matrices, :price, :line_haul
    add_column :pricing_matrices, :line_haul_plus_29_5_fuel_surcharge, :decimal, precision: 10, scale: 2
  end
end
