class CreateInteractionCategories < ActiveRecord::Migration
  def change
    create_table :interaction_categories do |t|
      t.string :name
      t.integer :sortorder
      t.integer :employeeid
      t.integer :resolutionhours

      t.timestamps
    end
  end
end
