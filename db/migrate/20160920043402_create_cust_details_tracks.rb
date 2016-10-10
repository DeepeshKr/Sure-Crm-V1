class CreateCustDetailsTracks < ActiveRecord::Migration
  def change
    create_table :cust_details_tracks do |t|
      t.belongs_to :order_master, index: true, unique: true, foreign_key: true
      t.integer :order_ref_id
      t.datetime :order_date
      t.integer :ext_ref_id
      t.integer :custdetails
      t.integer :vpp
      t.integer :dealtran
      t.datetime :last_call_back_on
      t.integer :no_of_attempts
      t.string :mobile
      t.string :alt_mobile
      t.text :products
      t.string :current_status

      t.timestamps null: false
    end
    
  end
end
