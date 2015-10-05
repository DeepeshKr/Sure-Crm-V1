class AddFramesToMediaTape < ActiveRecord::Migration
  def change
    add_column :media_tapes, :frames, :integer
  end
end
