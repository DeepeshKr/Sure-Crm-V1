class AddShippingCostToSalesPpo < ActiveRecord::Migration
  def change
    add_column :sales_ppos, :shipping_cost, :decimal
  end
end
