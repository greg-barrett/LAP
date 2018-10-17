class CreateReservations < ActiveRecord::Migration[5.1]
  def change
    create_table :reservations do |t|
      t.date :arrival_date
      t.date :departure_date
      t.boolean :confirmed
      t.float :fee
      t.integer :party_size
      t.text :notes
      t.integer :reserver_id

      t.timestamps
    end
    add_index :reservations, :arrival_date, unique: true
    add_index :reservations, :departure_date, unique: true
    add_index :reservations, :reserver_id
  end
end
