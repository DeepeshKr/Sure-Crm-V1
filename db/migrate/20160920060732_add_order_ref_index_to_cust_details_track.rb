class AddOrderRefIndexToCustDetailsTrack < ActiveRecord::Migration
  def change
    add_index :cust_details_tracks, :ext_ref_id
    add_index :cust_details_tracks, :order_date
    add_index :cust_details_tracks, :custdetails
    add_index :cust_details_tracks, :vpp
    add_index :cust_details_tracks, :dealtran
    add_index :cust_details_tracks, :last_call_back_on
    add_index :cust_details_tracks, :mobile
    add_index :cust_details_tracks, :alt_mobile
  end
end
