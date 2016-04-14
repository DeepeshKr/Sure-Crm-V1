class AddExtproductcodeIndexToProductList < ActiveRecord::Migration
  def change
    add_index :product_lists, :extproductcode
    add_index :product_lists, :list_barcode
    add_index :product_lists, :name
    add_index :product_lists, :product_variant_id
    add_index :product_lists, :product_master_id
    add_index :product_lists, :product_spec_list_id
  end
end
