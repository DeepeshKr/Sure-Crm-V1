class AddLastmileFinalStatusToOrderMaster < ActiveRecord::Migration
  def change
    add_column :order_masters, :order_last_mile_id, :integer
    add_column :order_masters, :order_final_status_id, :integer
  end
end
