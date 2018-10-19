class AddEmailToAdmins < ActiveRecord::Migration[5.1]
  def change
    add_column :admins, :email, :string, null: false, default: ""
    remove_column :admins, :username
    add_index :admins, :email, unique: true
  end
end
