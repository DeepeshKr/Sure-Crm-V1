class AddMediaIdToOrderMaster < ActiveRecord::Migration
  def change
    add_column :order_masters, :media_id, :integer
  end
end
