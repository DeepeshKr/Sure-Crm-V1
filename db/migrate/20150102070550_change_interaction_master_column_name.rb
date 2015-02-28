class ChangeInteractionMasterColumnName < ActiveRecord::Migration
  
  def change
      rename_column :interaction_masters, :interactionstatusid, :interaction_status_id
      rename_column :interaction_masters, :interactioncategoryid, :interaction_category_id
      rename_column :interaction_masters, :productvariantid, :product_variant_id
      rename_column :interaction_masters, :interactionpriorityid, :interaction_priority_id
      rename_column :interaction_masters, :campaignplaylistid, :campaign_playlist_id
end


end
