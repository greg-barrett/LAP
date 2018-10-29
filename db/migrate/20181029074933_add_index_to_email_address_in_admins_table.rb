class AddIndexToEmailAddressInAdminsTable < ActiveRecord::Migration[5.1]
  def change
    add_index :admins, :email_address, unique: true

  end
end
