class AddCreateatToRecord < ActiveRecord::Migration[5.2]
  def change
    add_column :records, :created_at, :datetime 
  end
end
