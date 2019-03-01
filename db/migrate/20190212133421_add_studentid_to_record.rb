class AddStudentidToRecord < ActiveRecord::Migration[5.2]
  def change
    add_reference :records, :student, foreign_key: true, index: true
  end
end
