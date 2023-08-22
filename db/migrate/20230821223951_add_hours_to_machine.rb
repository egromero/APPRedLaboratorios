class AddHoursToMachine < ActiveRecord::Migration[5.2]
  def change
    add_column :machines, :start_hour, :string
    add_column :machines, :end_hour, :string
    add_column :machines, :lunch, :integer
  end
end
