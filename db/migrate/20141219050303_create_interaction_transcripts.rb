class CreateInteractionTranscripts < ActiveRecord::Migration
  def change
    create_table :interaction_transcripts do |t|
      t.integer :interactionid
      t.string :interactionuserid
      t.text :description
      t.string :callednumber
       
      t.timestamps
    end
  end
end
