class AddInteractionMasterIdToOrderMaster < ActiveRecord::Migration
  def change
    add_column :order_masters, :interaction_master_id, :integer
    add_index :order_masters, :interaction_master_id
  end
end
