class AddIndexToExternalOrderNoToOrderMaster < ActiveRecord::Migration
  def change
    add_index :order_masters, :external_order_no
  end
end
