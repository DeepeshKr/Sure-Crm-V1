class CreateInteractionPriorities < ActiveRecord::Migration
  def change
    create_table :interaction_priorities do |t|
      t.string :name
      t.integer :sortorder

      t.timestamps
    end
  end
end
