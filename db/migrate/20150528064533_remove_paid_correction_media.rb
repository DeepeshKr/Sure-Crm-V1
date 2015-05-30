class RemovePaidCorrectionMedia < ActiveRecord::Migration
  def change
  	remove_column :media, :paid_correction
  end
end
