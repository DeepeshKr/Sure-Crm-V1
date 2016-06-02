class AddDeptToMedia < ActiveRecord::Migration
  def change
    add_column :media, :dept, :string
    add_index :media, :dept
  end
end
