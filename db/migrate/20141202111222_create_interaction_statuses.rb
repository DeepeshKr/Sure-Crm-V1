class CreateInteractionStatuses < ActiveRecord::Migration
  def change
    create_table :interaction_statuses do |t|
      t.string :customer_description
      t.string :internal_description
      t.integer :sortorder

      t.timestamps
    end
  end
end
