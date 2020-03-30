class AddFaultvalueToRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :records, :foul, :boolean, default: false
  end
end
