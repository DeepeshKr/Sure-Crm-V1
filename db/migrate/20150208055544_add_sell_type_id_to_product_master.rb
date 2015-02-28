class AddSellTypeIdToProductMaster < ActiveRecord::Migration
  def change
    add_column :product_masters, :product_sell_type_id, :integer
  end
end
