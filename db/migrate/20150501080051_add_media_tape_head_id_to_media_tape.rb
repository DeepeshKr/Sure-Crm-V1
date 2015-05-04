class AddMediaTapeHeadIdToMediaTape < ActiveRecord::Migration
  def change
    add_column :media_tapes, :media_tape_head_id, :integer
  end
end
