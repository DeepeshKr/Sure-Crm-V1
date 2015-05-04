class AddSortOrderToMediaTape < ActiveRecord::Migration
  def change
    add_column :media_tapes, :sort_order, :integer
  end
end
