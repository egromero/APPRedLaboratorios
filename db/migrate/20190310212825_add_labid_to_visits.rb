class AddLabidToVisits < ActiveRecord::Migration[5.2]
  def change
    add_column :visits, :lab_id, :integer
  end
end
