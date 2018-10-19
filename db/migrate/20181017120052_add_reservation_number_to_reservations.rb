class AddReservationNumberToReservations < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :reservation_number, :string
    add_index :reservations, :reservation_number, unique: true
  end
end
