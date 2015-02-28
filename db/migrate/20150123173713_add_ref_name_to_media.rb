class AddRefNameToMedia < ActiveRecord::Migration
  def change
    add_column :media, :ref_name, :string
  end
end
