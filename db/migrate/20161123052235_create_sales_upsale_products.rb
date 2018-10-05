class CreateSalesUpsaleProducts < ActiveRecord::Migration
  def change
    create_table :sales_upsale_products do |t|
      t.integer :product_list_id

      t.timestamps null: false
    end
    
    add_index :sales_upsale_products, :product_list_id, :unique => true
  end
  
end
