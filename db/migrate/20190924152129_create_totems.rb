class CreateTotems < ActiveRecord::Migration[5.2]
  def change
    create_table :totems do |t|
      t.string :api_key

      t.timestamps
    end
  end
end
