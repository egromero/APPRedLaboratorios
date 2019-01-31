class CreateRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :records do |t|
      t.integer :id_usuario
      t.string :tipo

      t.timestamps
    end
  end
end
