class CreateReservers < ActiveRecord::Migration[5.1]
  def change
    create_table :reservers do |t|
      t.string :title
      t.string :first_name
      t.string :last_name
      t.string :id_type
      t.string :id_number
      t.string :contact_number
      t.string :email_address
      t.string :house_number
      t.string :street_name
      t.string :city
      t.string :country
      t.string :postcode

      t.timestamps
    end
    add_index :reservers, :last_name
    add_index :reservers, :email_address
  end
end
