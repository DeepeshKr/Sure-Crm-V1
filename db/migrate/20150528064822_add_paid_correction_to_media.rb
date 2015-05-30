class AddPaidCorrectionToMedia < ActiveRecord::Migration
  def change
    add_column :media, :paid_correction, :decimal, :precision => 6, :scale => 5
  end
end
