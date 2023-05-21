class CreateMachines < ActiveRecord::Migration[5.2]
  def change
    create_table :machines do |t|
      t.string :name
      t.float :weight
      t.boolean :is_available, default: true
      t.integer :lab_id
      t.string :description
      t.timestamps
    end
  end
end
