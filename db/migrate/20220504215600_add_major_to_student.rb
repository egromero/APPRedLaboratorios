class AddMajorToStudent < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :major, :string
  end
end
