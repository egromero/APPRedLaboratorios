class AddLabidtoUsers < ActiveRecord::Migration[5.2]
  def change
     add_column :users, :lab_id, :integer
  end
end
