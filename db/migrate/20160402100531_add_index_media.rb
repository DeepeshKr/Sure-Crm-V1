class AddIndexMedia < ActiveRecord::Migration
  def change
    add_index :media, :telephone
    add_index :media, :media_group_id
    add_index :media, :dnis
    add_index :media, :daily_charges
    add_index :media, :name
    add_index :media, :ref_name
    add_index :media, :media_commision_id
  end
end
