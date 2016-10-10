class CreateProductMasterImages < ActiveRecord::Migration
  def change
    create_table :product_master_images do |t|
      t.string :name
      t.text :description
      t.integer :sort_order
      t.integer :product_master_id
      t.string :prod
      t.string :barcode
      t.integer :product_variant_id
      t.integer :product_list_id
      
      t.timestamps null: false
    end
  end
end
