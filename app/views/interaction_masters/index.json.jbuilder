json.array!(@interaction_masters) do |interaction_master|
  json.extract! interaction_master, :id, :createdon, :resolveby, :interactionstatusid, :customerid, :interactioncategoryid, :productvariantid, :orderid, :interactionpriorityid, :campaignplaylistid, :notes
  json.url interaction_master_url(interaction_master, format: :json)
end
