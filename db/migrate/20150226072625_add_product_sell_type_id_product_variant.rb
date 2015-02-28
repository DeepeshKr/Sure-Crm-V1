class AddProductSellTypeIdProductVariant < ActiveRecord::Migration
  def change
  	 add_column :product_variants, :product_sell_type_id, :integer
  end
end
