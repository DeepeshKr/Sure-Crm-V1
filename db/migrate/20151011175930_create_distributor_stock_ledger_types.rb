class CreateDistributorStockLedgerTypes < ActiveRecord::Migration
  def change
    create_table :distributor_stock_ledger_types do |t|
      t.string :name
      t.integer :sort_order
      t.text :description

      t.timestamps null: false
    end
  end
end
