class CreateSalesPpoProductAlerts < ActiveRecord::Migration
  def change
    create_table :sales_ppo_product_alerts do |t|
      t.integer :product_list_id

      t.timestamps null: false
    end
  end
end
