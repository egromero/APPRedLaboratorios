class DeleteIduserToUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users , :id_lab 
  end
end
