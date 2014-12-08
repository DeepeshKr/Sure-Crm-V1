class CreateProductInventoryCodes < ActiveRecord::Migration
  def change
    create_table :product_inventory_codes do |t|
      t.string :name
      t.integer :sortorder

      t.timestamps
    end
  end
end
