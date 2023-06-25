class CreateReservations < ActiveRecord::Migration[5.2]
  def change
    create_table :reservations do |t|
      ## date of reservation
      t.date :date
      t.integer :hour_block
      t.integer :student_id
      t.integer :machine_id
      t.integer :lab_id
      t.timestamps
    end
  end
end
