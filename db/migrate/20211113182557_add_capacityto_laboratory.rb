class AddCapacitytoLaboratory < ActiveRecord::Migration[5.2]
  def change
    add_column :laboratories, :capacity, :integer, default: 1
  end
end
