class CreateCustomerAddresses < ActiveRecord::Migration
  def change
    create_table :customer_addresses do |t|
      t.integer :customer_id
      t.string :name
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :landmark
      t.string :city
      t.string :pincode
      t.string :state
      t.string :district
      t.string :country
      t.string :telephone1
      t.string :telephone2
      t.string :fax
      t.text :description
      t.integer :valid_id

      t.timestamps
    end
  end
end
