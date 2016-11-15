class AddDateOfBirthToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :date_of_birth, :datetime
    add_index :customers, :date_of_birth
  end
end
