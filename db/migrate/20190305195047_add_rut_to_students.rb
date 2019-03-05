class AddRutToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :rut, :string
  end
end
