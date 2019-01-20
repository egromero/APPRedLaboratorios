class CreateJoinTableStudentLaboratory < ActiveRecord::Migration[5.2]
  def change
    create_join_table :students, :laboratories do |t|
       t.index [:student_id, :laboratory_id]
       t.index [:laboratory_id, :student_id]
    end
  end
end
