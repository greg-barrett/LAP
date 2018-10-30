class AddAdminColToReservers < ActiveRecord::Migration[5.1]
  def change
    add_column :reservers, :admin, :boolean, default: false
  end
end
