class CreateSalesPpoEmailAlerts < ActiveRecord::Migration
  def change
    create_table :sales_ppo_email_alerts do |t|
      t.string :email_id
      t.datetime :last_delivered_on

      t.timestamps null: false
    end
  end
end
