class CreateDistributorStockLedgers < ActiveRecord::Migration
  def change
    create_table :distributor_stock_ledgers do |t|
      t.integer :corporate_id
      t.integer :product_master_id
      t.integer :product_variant_id
      t.integer :product_list_id
      t.string :prod
      t.string :name
      t.text :description
      t.float :stock_change
      t.date :ledger_date

      t.timestamps null: false
    end
  end
end
