class AddPhoneToFatToFitEmailStatus < ActiveRecord::Migration
  def change
    add_column :fat_to_fit_email_statuses, :phone, :string
    add_column :fat_to_fit_email_statuses, :state, :string
    add_column :fat_to_fit_email_statuses, :city, :string
    add_column :fat_to_fit_email_statuses, :registration_status_id, :integer
  end
end
