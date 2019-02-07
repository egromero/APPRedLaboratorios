class AddIdlabToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :laboratories, :user, index: true
    add_foreign_key :laboratories, :users
  end
end
