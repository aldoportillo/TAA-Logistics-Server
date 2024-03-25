class AddContactedToQuote < ActiveRecord::Migration[7.1]
  def change
    add_column :quotes, :contacted, :boolean
  end
end
