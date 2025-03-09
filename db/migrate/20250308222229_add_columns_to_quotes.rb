class AddColumnsToQuotes < ActiveRecord::Migration[7.1]
  def change
    add_column :quotes, :destination, :string
    add_column :quotes, :rate_per_mile, :float
    add_column :quotes, :fsch_percent, :float
    add_column :quotes, :miles, :float
    add_column :quotes, :line_haul, :float
    add_column :quotes, :fuel_surcharge, :float
    add_column :quotes, :total, :float
  end
end
