class AddCommissionOnOrderToSalesPpo < ActiveRecord::Migration
  def change
    add_column :sales_ppos, :commission_on_order, :decimal, :precision => 14, :scale => 4
  end
end
