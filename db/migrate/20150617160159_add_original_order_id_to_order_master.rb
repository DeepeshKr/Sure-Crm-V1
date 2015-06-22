class AddOriginalOrderIdToOrderMaster < ActiveRecord::Migration
  def change
    add_column :order_masters, :original_order_id, :integer
  end
end
