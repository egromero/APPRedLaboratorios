class CreateTableRecord < ActiveRecord::Migration[5.2]
  def change
    create_table :table_records do |t|
      t.string :tipo
    end
  end
end
