class CreateProductMasterAddOns < ActiveRecord::Migration
  def change
    create_table :product_master_add_ons do |t|
      t.integer :product_master_id
      t.integer :product_list_id
      t.integer :activeid
      t.decimal :change_price

      t.timestamps null: false
    end
  end
end
