class AddStockValueToDistributorStockLedger < ActiveRecord::Migration
  def change
    add_column :distributor_stock_ledgers, :stock_value, :decimal
  end
end
