class CustDetailsTrackLog < ActiveRecord::Base
  belongs_to :cust_details_track
  
  def self.update_log track_id, name, description
     t = Time.zone.now + 330.minutes
     
     cust_details_track_log = CustDetailsTrackLog.new do |n|
       cust_details_track_log_id = track_id
       description = "#{description} at #{t}",
       name = "#{name}"
     end
     cust_details_track_log.save
  end
end
