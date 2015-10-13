class AddTypeIdToDistributorStockLedger < ActiveRecord::Migration
  def change
    add_column :distributor_stock_ledgers, :type_id, :integer
  end
end
