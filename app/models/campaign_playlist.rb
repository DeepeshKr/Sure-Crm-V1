class CampaignPlaylist < ActiveRecord::Base
  require 'securerandom'
  attr_accessor :generate_unique_secure_token
  attr_accessor :cost_per_sec
  belongs_to :campaign, foreign_key: "campaignid"
  belongs_to :product_variant, foreign_key: "productvariantid"
  belongs_to :media_tape, foreign_key: "tape_id"

  belongs_to :campaign_play_list_status, foreign_key: "list_status_id"

  has_many :order_master, foreign_key: "campaign_playlist_id"
  has_many :sales_ppo, foreign_key: "campaign_playlist_id"
  has_many :campaign_playlist_to_product, foreign_key: "campaign_playlist_id"

  validates :productvariantid, allow_blank: true,  numericality: { only_integer: true }
  validates :campaignid, numericality: { only_integer: true }
  validates :name, length: { maximum: 500 }
  validates_presence_of :start_hr, :start_min, :start_sec, :end_hr, :end_min, :end_sec, :cost

  validates :start_sec, :inclusion => { :in => 0..59, :message => "The seconds should be between 0 and 59" }
  validates :end_sec, :inclusion => { :in => 0..59, :message => "The seconds should be between 0 and 59" }

  validates :start_min, :inclusion => { :in => 0..59, :message => "The minutes should be between 0 and 59" }
  validates :end_min, :inclusion => { :in => 0..59, :message => "The minutes should be between 0 and 59" }

  validates :start_hr, :inclusion => { :in => 0..23, :message => "The hours should be between 0 and 23" }
  validates :end_hr, :inclusion => { :in => 0..23, :message => "The hours should be between 0 and 23" }
  #validate :time_validation
  validates :start_frame, :inclusion => { :in => 0..24, :message => "The frames should be between 0 and 24" }, allow_nil: true
  validates :end_frame, :inclusion => { :in => 0..24, :message => "The frames should be between 0 and 24"}, allow_nil: true

  #validate :time_validation

 # validates :starttime
 # validates :endtime
  #http://guides.rubyonrails.org/v3.2.19/active_record_querying.html#array-conditions
  def sales
      OrderMaster.where('campaign_playlist_id = ?', self.id).where('ORDER_STATUS_MASTER_ID > 10002').sum(:total) || 0
  end

  def pieces
      OrderMaster.where('campaign_playlist_id = ?', self.id).where('ORDER_STATUS_MASTER_ID > 10002').sum(:pieces) || 0
  end

  def time_validation
      if self[:endtime] < self[:starttime]
        errors[:endtime] << "can't be in less than %d" %[starttime]
        return false
      else
        return true
      end
  end

  def to_xml

  end

  def generate_unique_secure_token
    SecureRandom.uuid
      #  SecureRandom.base58(24)
  end
 
  def starttime
   # str = ":"
       #  self.end_hr + ":" + self.end_min + ":" + self.end_sec
       #str.concat(self.start_hr)
        self.start_hr.to_s.rjust(2, '0') << ":" << self.start_min.to_s.rjust(2, '0')  << ":" << self.start_sec.to_s.rjust(2, '0') << ":" << self.start_frame.to_s.rjust(2, '0')
      #t = (self.end_hr + ":" + self.end_min + ":" + self.end_sec)  - (self.start_hr + ":" + self.start_min + ":" + self.start_sec)
     # mm, ss = t.divmod(60)
     #  "%d m %d s" % [mm, ss]

  end
  
  def endtime
     #str = ":"
     #  self.end_hr + ":" + self.end_min + ":" + self.end_sec
     #str.concat(self.end_hr)
      self.end_hr.to_s.rjust(2, '0') << ":" << self.end_min.to_s.rjust(2, '0') << ":" << self.end_sec.to_s.rjust(2, '0') << ":" << self.end_frame.to_s.rjust(2, '0')
     # self.start_hr + ":" + self.start_min + ":" + self.start_sec
    #t = (self.end_hr + ":" + self.end_min + ":" + self.end_sec)  - (self.start_hr + ":" + self.start_min + ":" + self.start_sec)
   # mm, ss = t.divmod(60)
   #  "%d m %d s" % [mm, ss]

  end

  def duration_frames
    self.duration_secs.to_s.rjust(2, '0') << ":" << self.frames.to_s.rjust(2, '0')
  end

  def playtime
   hour_min_sec(self.start_hr, self.start_min, self.start_sec, self.end_hr, self.end_min, self.end_sec)
  end

  def playlistinfo
    #self.product_variant.name + " between " + self.start_hr || 0 + ":" + self.start_min + ":" + self.start_sec + " to " + self.end_hr + ":" + self.end_min + ":" + self.end_sec + " (" + self.name + ") "
    self.product_variant.name + " between " + self.start_hr.to_s.rjust(2, '0') || 0 + ":"  +  " (" + self.name + ") "
  end

  def playlist_details
    #self.product_variant.name + " between " + self.start_hr || 0 + ":" + self.start_min + ":" + self.start_sec + " to " + self.end_hr + ":" + self.end_min + ":" + self.end_sec + " (" + self.name + ") "
    self.product_variant.name + " on " + self.for_date.strftime("%d-%b-%y") || nil + " " + self.start_hr.to_s.rjust(2, '0') || "00" + ":" + self.start_min.to_s.rjust(2, '0') || "00"
  end

  def productrevenue
     orderrevenue =  OrderMaster.where(campaign_playlist_id: self.id)
    if orderrevenue.present?
        total = 0
        orderrevenue.each do |c|
          total += c.productrevenue
        end
      return total

    else
      return 0
    end

  end

  def productcost
      ordercost =  OrderMaster.where(campaign_playlist_id: self.id).where('ORDER_STATUS_MASTER_ID > 10002')

      if ordercost.present?
        total = 0
        ordercost.each do |c|
          total += c.productcost
        end
      return total

      else
        return 0
      end
  end

  def add_sec_fr

    #(s_hr, s_min, s_sec, s_ff, duration_seconds, duration_ff)
     extra_secs = 0
     totalseconds = 0
     self.frames = 0 if self.frames.blank?
     self.start_frames = 0 if self.start_frames.blank?
     self.end_hour, self.end_min, self.end_second, self.end_frames, self.day = 0,0,0,0,0

      self.end_frames = (self.start_frames.to_i + self.frames.to_i) % 24
      if (self.start_frames.to_i + self.frames.to_i) > 23
       extra_secs = 1
      end

      first = (self.start_hour.to_i * 60 * 60) + (self.start_min.to_i * 60) + self.start_second.to_i
      duration_seconds =   self.seconds.to_i + extra_secs.to_i

      totalseconds = duration_seconds + first
      self.end_second =  totalseconds % 60
      totalseconds = (totalseconds - self.end_second) / 60
      self.end_min =  totalseconds % 60
      totalseconds = (totalseconds - self.end_min) / 60
      self.end_hour =  totalseconds % 24
      end_day = 1 if (totalseconds - end_hour) > 0
      # if (totalseconds % 24) >= 24
      #   self.day = 1
      # end
  end

  # CampaignPlaylist.calculate_total_seconds_to_day 1800
  def self.calculate_total_seconds_to_day totalseconds
    end_second, end_min,end_hour, end_day = 0,0,0,0

    end_second =  totalseconds % 60
    totalseconds = (totalseconds - end_second) / 60
    end_min =  totalseconds % 60
    totalseconds = (totalseconds - end_min) / 60
    end_hour =  totalseconds % 24
    end_day = 1 if (totalseconds - end_hour) > 0

    puts "This duration is #{end_day} days #{end_hour} hours #{end_min} mins and #{end_second} secs"
  end

  def playlist_group_seconds
    return 0 if self.playlist_group_id.blank?
    return CampaignPlaylist.where(playlist_group_id: self.playlist_group_id).sum(:duration_secs)
  end

  def playlist_group_minutes
    return 0 if self.playlist_group_id.blank?
    totalseconds = CampaignPlaylist.where(playlist_group_id: self.playlist_group_id).sum(:duration_secs)

    # total_minutes = 0
    # total_hours = 0
    # balance_secs = totalseconds % 60
    # total_minutes = ((total_seconds - balance_secs) / 60)  % 60
    # 
    end_second =  totalseconds % 60
    totalseconds = (totalseconds - end_second) / 60
    end_min =  totalseconds % 60
    totalseconds = (totalseconds - end_min) / 60
    end_hour =  totalseconds % 24
    end_day = 1 if (totalseconds - end_hour) > 0
    #total_hours = ((total_seconds - total_minutes) / 60) % 24
    return  "#{end_hour.to_s.rjust(2, '0')}:#{end_min.to_s.rjust(2, '0')}:#{end_second.to_s.rjust(2, '0')}"
  end

  def playlist_group_end_time
    return 0 if self.playlist_group_id.blank?

    campaign = CampaignPlaylist.where(playlist_group_id: self.playlist_group_id).last

    "#{campaign.end_hr.to_s.rjust(2, '0')}:#{campaign.end_min.to_s.rjust(2, '0')}:#{campaign.end_sec.to_s.rjust(2, '0')}:#{campaign.end_frame.to_s.rjust(2, '0')}"

  end

  def cost_of_group_playlist
    return 0 if self.playlist_group_id.blank?
    
    total_cost = CampaignPlaylist.where(playlist_group_id: self.playlist_group_id).sum(:cost)
    #campaign_playlist = CampaignPlaylist.find(self.id)
    self.update_column(:group_total_cost, total_cost)
    #self.group_total_cost = total_cost
    return "#{total_cost}"
  end

  def group_playlist_cost_update
    return 0 if self.playlist_group_id.present?
    
      total_cost = CampaignPlaylist.where(playlist_group_id: self.playlist_group_id).sum(:cost)
      #campaign_playlist = CampaignPlaylist.find(self.id)
      self.update_column(:group_total_cost, total_cost)
      return total_cost
  end
  # ca = CampaignPlaylist.find_by_campaignid(16103)
  # ca.group_playlist_cost_update
# after_create :updatecampaign , :group_playlist_cost_update

# after_update :updatecampaign , :group_playlist_cost_update

private


  def hour_min_sec(s_hr,s_min, s_sec, e_hr, e_min, e_sec)
       first = (s_hr.to_i * 60 * 60) + (s_min.to_i * 60) + s_sec.to_i
       last = (e_hr.to_i * 60 * 60) + (e_min * 60) + e_sec.to_i

      difference = last - first
      seconds    =  difference % 60
      difference = (difference - seconds) / 60
      minutes    =  difference % 60
      difference = (difference - minutes) / 60
      hours      =  difference % 24

      return hours.to_s.rjust(2, '0') << ":" << minutes.to_s.rjust(2, '0') << ":" << seconds.to_s.rjust(2, '0')

  end

  def updatecampaign
    campaign = Campaign.find(self.campaignid)
    campaign.update(cost: CampaignPlaylist.where('campaignid = ?', self.campaignid).sum(:cost))


  end

  def group_playlist_cost_update
    if self.playlist_group_id.present?
        total_cost = CampaignPlaylist.where(playlist_group_id: self.playlist_group_id).sum(:cost)
        #campaign_playlist = CampaignPlaylist.find(self.id)
        self.update_column(:group_total_cost, total_cost)
        #self.group_total_cost = total_cost
    end
  end
 #   create_table "campaign_playlists", force: :cascade do |t|
 #      t.string   "name"
 #      t.integer  "campaignid",        precision: 38
 #      t.integer  "productvariantid",  precision: 38
 #      t.string   "filename"
 #      t.text     "description"
 #      t.decimal  "cost"
 #      t.datetime "created_at"
 #      t.datetime "updated_at"
 #      t.string   "channeltapeid"
 #      t.string   "internaltapeid"
 #      t.integer  "start_hr",          precision: 38
 #      t.integer  "start_min",         precision: 38
 #      t.integer  "start_sec",         precision: 38
 #      t.integer  "end_hr",            precision: 38
 #      t.integer  "end_min",           precision: 38
 #      t.integer  "end_sec",           precision: 38
 #      t.integer  "duration_secs",     precision: 38
 #      t.integer  "tape_id",           precision: 38
 #      t.string   "ref_name"
 #      t.integer  "list_status_id",    precision: 38
 #      t.datetime "for_date"
 #      t.integer  "total_revenue",     precision: 38
 #      t.integer  "playlist_group_id", precision: 38
 #      t.integer  "start_frame",       precision: 38
 #      t.integer  "end_frame",         precision: 38
 #      t.integer  "frames",            precision: 38
 #      t.integer  "day",               precision: 38
 #    end
end
