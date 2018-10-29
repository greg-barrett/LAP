class AddPasswordToReservers < ActiveRecord::Migration[5.1]
  def change
    add_column :reservers, :password_digest, :string
  end
end
