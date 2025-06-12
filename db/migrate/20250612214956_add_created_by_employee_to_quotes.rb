class AddCreatedByEmployeeToQuotes < ActiveRecord::Migration[7.1]
  def change
    add_column :quotes, :created_by_employee, :boolean, default: false, null: false
  end
end
