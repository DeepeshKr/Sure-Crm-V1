class CreateProductWarehouses < ActiveRecord::Migration
  def change
    create_table :product_warehouses do |t|
      t.string :location_name
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :landmark
      t.string :city
      t.string :pincode
      t.string :state
      t.string :country
      t.string :telephone1
      t.string :telephone2
      t.string :fax
      t.string :emailid
      t.text :description

      t.timestamps
    end
  end
end
