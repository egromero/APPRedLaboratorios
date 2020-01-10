class CreateFlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :flayers do |t|
      t.string :tittle

      t.timestamps
    end
  end
end
