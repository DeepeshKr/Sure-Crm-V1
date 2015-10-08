class CreateDistributorStockSummaries < ActiveRecord::Migration
  def change
    create_table :distributor_stock_summaries do |t|
      t.integer :corporate_id
      t.integer :product_master_id
      t.integer :product_variant_id
      t.integer :product_list_id
      t.string :prod
      t.integer :stock_qty
      t.decimal :stock_value
      t.integer :stock_returned
      t.date :summary_date

      t.timestamps null: false
    end
  end
end
