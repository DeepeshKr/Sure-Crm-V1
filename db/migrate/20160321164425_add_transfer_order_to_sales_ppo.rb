class AddTransferOrderToSalesPpo < ActiveRecord::Migration
  def change
    add_column :sales_ppos, :transfer_order_revenue, :decimal
    add_column :sales_ppos, :transfer_order_dealer_price, :decimal
  end
end
