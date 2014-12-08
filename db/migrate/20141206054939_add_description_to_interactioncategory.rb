class AddDescriptionToInteractioncategory < ActiveRecord::Migration
  def change
    add_column :interaction_categories, :description, :string
  end
end
