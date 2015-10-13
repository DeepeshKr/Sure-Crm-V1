class AddWebIdToCorporate < ActiveRecord::Migration
  def change
    add_column :corporates, :web_id, :integer
    add_column :corporates, :ref_no, :integer
  end
end
