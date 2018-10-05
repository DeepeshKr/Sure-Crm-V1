class CreateMarketingMessages < ActiveRecord::Migration
  def change
    create_table :marketing_messages do |t|
      t.string :name
      t.text :description
      t.integer :total_nos
      t.boolean :activate
      t.datetime :start_date
      t.datetime :end_date
      t.integer :order_paymentmodeid

      t.timestamps null: false
    end
  end
end
