class CreateSalesPpos < ActiveRecord::Migration
  def change
    create_table :sales_ppos do |t|
      t.integer :campaign_playlist_id
      t.integer :campaign_id
      t.integer :product_master_id
      t.integer :product_variant_id
      t.integer :product_list_id
      t.string :prod
      t.string :name
      t.datetime :start_time
      t.integer :order_id
      t.integer :order_line_id
      t.decimal :product_cost
      t.integer :pieces
      t.decimal :revenue
      t.decimal :damages
      t.decimal :returns
      t.decimal :commission_cost
      t.decimal :promotion_cost
      t.decimal :media_cost
      t.decimal :gross_sales
      t.decimal :net_sale
      t.integer :external_order_no
      t.integer :order_status_id
      t.integer :order_last_mile_id
      t.string :order_pincode
      t.integer :media_id
      t.decimal :media_cost_total
      t.decimal :promo_cost_total
      t.string :dnis
      t.string :city
      t.string :state
      t.string :mobile_no

      t.timestamps null: false
    end
  end
end
