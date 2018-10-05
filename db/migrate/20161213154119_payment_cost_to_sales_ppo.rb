class PaymentCostToSalesPpo < ActiveRecord::Migration
  def change
    add_column :sales_ppos, :payment_cost, :decimal
  end
end
