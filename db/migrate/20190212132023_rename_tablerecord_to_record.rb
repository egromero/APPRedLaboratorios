class RenameTablerecordToRecord < ActiveRecord::Migration[5.2]
  def change
    rename_table :table_records, :records
  end
end
