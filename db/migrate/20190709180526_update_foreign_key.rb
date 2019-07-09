class UpdateForeignKey < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :records, :students
    add_foreign_key :records, :students, on_delete: :cascade
  end
end
