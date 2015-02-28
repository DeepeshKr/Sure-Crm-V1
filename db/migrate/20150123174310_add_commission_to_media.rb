class AddCommissionToMedia < ActiveRecord::Migration
  def change
    add_column :media, :media_commision_id, :integer
    add_column :media, :value, :float
    add_column :media, :media_group_id, :integer
  end
end
