class AddIndexToProductMasterImage < ActiveRecord::Migration
  def change
    add_index :product_master_images, :name
    add_index :product_master_images, :product_master_id
    add_index :product_master_images, :prod
    add_index :product_master_images, :barcode
    add_index :product_master_images, :product_variant_id
    add_index :product_master_images, :product_list_id
  end
end
