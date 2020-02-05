class AddValuesToVisit < ActiveRecord::Migration[5.2]
  def change
    add_column :visits, :other, :string
    add_column :visits, :quantity, :integer
  end
end
