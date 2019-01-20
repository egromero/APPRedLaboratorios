class CreateLaboratories < ActiveRecord::Migration[5.2]
  def change
    create_table :laboratories do |t|
      t.string :nombre
      t.string :facultad
      t.string :campus

      t.timestamps
    end
  end
end
