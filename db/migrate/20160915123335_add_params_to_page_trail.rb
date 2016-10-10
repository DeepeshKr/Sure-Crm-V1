class AddParamsToPageTrail < ActiveRecord::Migration
  def change
    # add_column :page_trails, :params, :text
 #    add_column :page_trails, :description, :text
   # add_index :page_trails, :order_id
   # add_index :page_trails, :name
    add_index :page_trails,:employee_id
    
  end
end
