class AddMobileToInteractionMaster < ActiveRecord::Migration
  def change
    add_column :interaction_masters, :mobile, :string
  end
end
