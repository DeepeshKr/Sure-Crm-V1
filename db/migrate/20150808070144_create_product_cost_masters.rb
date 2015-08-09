class CreateProductCostMasters < ActiveRecord::Migration
  def change
    create_table :product_cost_masters do |t|
      t.integer :product_id
      t.integer :product_list_id
      t.string :prod
      t.string :barcode
      t.integer :product_cost
      t.integer :basic_cost
      t.integer :shipping_handling
      t.integer :postage
      t.integer :tel_cost
      t.integer :transf_order_basic
      t.integer :dealer_network_basic
      t.integer :wholesale_variable_cost
      t.integer :royalty
      t.integer :cost_of_return
      t.integer :call_centre_commission

      t.timestamps null: false
    end
  end
end
