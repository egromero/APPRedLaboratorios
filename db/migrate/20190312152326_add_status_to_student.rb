class AddStatusToStudent < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :status, :boolean
  end
end
