class AddFieldToReservation < ActiveRecord::Migration[5.2]
  def change
    add_column :reservations, :status, :string, default: "creada"
  end  
end
