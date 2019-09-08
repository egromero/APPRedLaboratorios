class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :admin, :rol
    change_column :users, :rol, :string
  end
end
