class AddDailyChargesToMedium < ActiveRecord::Migration
  def change
    add_column :media, :daily_charges, :decimal
    add_column :media, :paid_correction, :decimal
  end
end
