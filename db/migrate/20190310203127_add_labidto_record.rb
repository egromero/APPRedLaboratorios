class AddLabidtoRecord < ActiveRecord::Migration[5.2]
  def change
    add_column :records, :lab_id, :integer
  end
end
