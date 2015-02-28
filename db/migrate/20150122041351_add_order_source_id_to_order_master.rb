class AddOrderSourceIdToOrderMaster < ActiveRecord::Migration
  def change
    add_column :order_masters, :order_source_id, :integer
  end
end
