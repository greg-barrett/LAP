class AddUniqueIndexToEmailAddressInReserversTable < ActiveRecord::Migration[5.1]
  def change
    add_index :reservers, :email_address, unique: true
  end
end
