class AddIndexToInteractionMasters < ActiveRecord::Migration
  def change
    add_index :interaction_masters, :orderid
    add_index :interaction_masters, :interaction_status_id
    add_index :interaction_masters, :customer_id
    add_index :interaction_masters, :interaction_category_id
    add_index :interaction_masters, :campaign_playlist_id
    add_index :interaction_masters, :employee_id
    add_index :interaction_masters, :employee_code
    add_index :interaction_masters, :mobile
  end
end
