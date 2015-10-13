class DistributorStockLedger < ActiveRecord::Base
	belongs_to :corporate, foreign_key: "corporate_id"
	belongs_to :product_master, foreign_key: "product_master_id"
	belongs_to :product_variant, foreign_key: "product_variant_id"
	belongs_to :product_list, foreign_key: "product_list_id"
	belongs_to :distributor_stock_ledger_type, foreign_key: "type_id"
end
