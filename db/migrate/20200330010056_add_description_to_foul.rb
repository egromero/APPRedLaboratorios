class AddDescriptionToFoul < ActiveRecord::Migration[5.2]
  def change
    add_column :records, :description, :string
  end
end
