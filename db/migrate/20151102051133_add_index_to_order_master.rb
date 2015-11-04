class AddIndexToOrderMaster < ActiveRecord::Migration
  def change
    add_index :order_masters, :pincode
    add_index :order_masters, :city
  end
end
