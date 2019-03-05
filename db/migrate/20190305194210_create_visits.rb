class CreateVisits < ActiveRecord::Migration[5.2]
  def change
    create_table :visits do |t|
      t.string :rut
      t.string :motivo
      t.string :institucion
      t.timestamps
    end
  end
end
