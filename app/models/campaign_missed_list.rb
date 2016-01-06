class CampaignMissedList < ActiveRecord::Base

  after_save :calculate_time_diff
  private
  def calculate_time_diff
    if self.campaign_playlist_id.present?
      campaign_playlist = CampaignPlaylist.find(self.campaign_playlist_id)

      campaign_date_time = corrected_date_time Date.strptime(campaign_playlist.for_date, "%Y-%m-%d"), campaign_playlist.start_hr, campaign_playlist.start_min

      curent_date_time = Datetime.now - 300.minutes

      date_diff = curent_date_time - DateTime.strptime(campaign_date_time, "%Y-%m-%d %H:%M:%S")

      self.update(order_time: curent_date_time)
      self.update(play_list_time: campaign_date_time)
      self.update(time_diff: date_diff)

    end


  end

  def corrected_date_time(for_date, for_hour, for_minute)
    for_hour = for_hour.to_s.rjust(2, '0')
    for_minute = for_minute.to_s.rjust(2, '0')
    for_date = for_date.strftime("%Y-%m-%d")
    #string_date = for_date + " " + for_hour + ":" + for_minute + ":00"
    base_date = DateTime.strptime("#{for_date} #{for_hour}:#{for_minute}:00 + 5:30", "%Y-%m-%d %H:%M:%S")
    #return return_date = DateTime.strptime(string_date, "%Y-%m-%d %H:%M:%S")
    return (base_date).strftime("%Y-%m-%d %H:%M:%S")

  end
end
# external pick the following
# "reason" "order_id" "campaign_playlist_id" "called_no" "customer_state" "media_id"

# create_table "campaign_missed_lists", force: :cascade do |t|
#   t.string   "reason"
#   t.text     "description"
#   t.datetime "created_at",                                     null: false
#   t.datetime "updated_at",                                     null: false
#   t.decimal  "time_diff"
#   t.datetime "order_time"
#   t.datetime "play_list_time"
#   t.integer  "order_id",             limit: 16, precision: 38
#   t.integer  "campaign_id",          limit: 16, precision: 38
#   t.integer  "campaign_playlist_id", limit: 16, precision: 38
#   t.string   "called_no"
#   t.string   "customer_state"
#   t.integer  "media_id",             limit: 16, precision: 38
# end

# create_table "campaign_playlists", force: :cascade do |t|
#   t.integer  "start_hr",          limit: 16, precision: 38
#   t.integer  "start_min",         limit: 16, precision: 38
#   t.integer  "start_sec",         limit: 16, precision: 38
#   t.datetime "for_date"
# end
