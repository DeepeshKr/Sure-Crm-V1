class ChangeColumnStockValueDistributorStockLedger < ActiveRecord::Migration
  def change
  	change_column :distributor_stock_ledgers, :stock_value, :decimal, precision: 10, scale: 2
  end
end
