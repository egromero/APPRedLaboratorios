class CreateStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :students do |t|
      t.string :rfid
      t.string :nombre
      t.string :nalumno
      t.string :sit_academica
      t.string :correo

      t.timestamps
    end
  end
end
