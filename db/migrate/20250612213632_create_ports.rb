class CreatePorts < ActiveRecord::Migration[7.1]
  def change
    create_table :ports do |t|
      t.string :name
      t.string :address
      t.boolean :active

      t.timestamps
    end
  end
end
