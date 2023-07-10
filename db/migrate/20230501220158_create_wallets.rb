class CreateWallets < ActiveRecord::Migration[5.2]
  def change
    create_table :wallets do |t|
      t.float :hours
      t.integer :student_id
      t.boolean :current, default: true
      t.timestamps
    end
  end
end
