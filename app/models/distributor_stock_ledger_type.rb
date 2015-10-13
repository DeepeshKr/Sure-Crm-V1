class DistributorStockLedgerType < ActiveRecord::Base
	has_many :distributor_stock_ledger, foreign_key: "type_id"
end
