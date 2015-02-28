class ChangeProductVariantAddOn < ActiveRecord::Migration
  def change
  	rename_column :product_variant_add_ons, :productid, :product_master_id
	rename_column :product_variant_add_ons, :productvariantid, :product_variant_id


  end
end
