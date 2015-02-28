class CreateInteractionMasters < ActiveRecord::Migration
  def change
    create_table :interaction_masters do |t|
      t.datetime :createdon
      t.datetime :closedon 
      t.datetime :resolveby
      t.integer :interactionstatusid
      t.integer :customer_id
      t.string :callednumber
      t.integer :interactioncategoryid
      t.integer :productvariantid
      t.integer :orderid
      t.integer :interactionpriorityid
      t.integer :campaignplaylistid
      t.text :notes
      t.string :state
      t.timestamps
    end
  end
end
