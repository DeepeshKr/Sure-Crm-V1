class AddExtproductcodeIndexToProductVariant < ActiveRecord::Migration
  def change
    add_index :product_variants, :extproductcode
    add_index :product_variants, :productmasterid
    add_index :product_variants, :variantbarcode
    add_index :product_variants, :product_sell_type_id
    add_index :product_variants, :activeid
  end
end
