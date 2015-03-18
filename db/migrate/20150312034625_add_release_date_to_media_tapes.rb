class AddReleaseDateToMediaTapes < ActiveRecord::Migration
  def change
    add_column :media_tapes, :release_date, :date
  end
end
