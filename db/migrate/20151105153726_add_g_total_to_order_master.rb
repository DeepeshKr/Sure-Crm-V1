class AddGTotalToOrderMaster < ActiveRecord::Migration
  def change
    add_column :order_masters, :g_total, :decimal, precision: 12, scale: 2
  end
end
