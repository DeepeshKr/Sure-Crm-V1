class CreateFatToFitEmailStatuses < ActiveRecord::Migration
  def change
    create_table :fat_to_fit_email_statuses do |t|
      t.string :emailid
      t.string :full_name
      t.string :products
      t.integer :order_no
      t.integer :order_id
      t.integer :send_status
      t.datetime :last_ran_date

      t.timestamps null: false
    end
  end
end
