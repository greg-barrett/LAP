class AddUniqnessToEmailIndex < ActiveRecord::Migration[5.1]
  def change
    remove_index :reservers, :email_address

  end
end
