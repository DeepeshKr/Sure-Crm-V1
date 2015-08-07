class AddProductCostToProductCostMaster < ActiveRecord::Migration
    def change
    add_column :product_cost_masters, :postage, :decimal, precision: 6, scale: 2
    add_column :product_cost_masters, :tel_cost, :decimal, precision: 6, scale: 2
    add_column :product_cost_masters, :tran_order_basic, :decimal, precision: 6, scale: 2
    add_column :product_cost_masters, :dealer_basic, :decimal, precision: 6, scale: 2
    add_column :product_cost_masters, :wholesale_variable_cost, :decimal, precision: 6, scale: 2
    add_column :product_cost_masters, :royalty, :decimal, precision: 6, scale: 2
    add_column :product_cost_masters, :return_cost, :decimal, precision: 6, scale: 2
    add_column :product_cost_masters, :call_center_comm, :decimal, precision: 6, scale: 2
    add_column :product_cost_masters, :shipping_handling, :decimal, precision: 6, scale: 2
    end
end
