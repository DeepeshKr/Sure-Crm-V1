class AddPaymentCostToOrderpaymentmode < ActiveRecord::Migration
  def change
    add_column :orderpaymentmodes, :payment_cost, :decimal, :precision => 6, :scale => 4
    add_column :orderpaymentmodes, :is_valid, :boolean
  end
end
