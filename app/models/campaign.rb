class Campaign < ActiveRecord::Base
  attr_accessor :csv_file_updated, :csv_file_errors, :campaign_id
  belongs_to :medium, foreign_key: "mediumid"
  belongs_to :campaign_stage, foreign_key: "campaignstageid"
  has_many :campaign_playlist, foreign_key: "campaignid"
  has_many :sales_ppo, foreign_key: "campaign_id"
   
  validates :name, length: { maximum: 500 }
  validates_presence_of :description
  validates_presence_of :startdate #, :enddate

  validates_uniqueness_of :mediumid, :scope => [:mediumid, :startdate], :message => "Not Saved, you have already created a campaign for date for the Media! "

  def sales 
  	campaignlist =  CampaignPlaylist.where('campaignid = ?', self.id)
      OrderMaster.where({campaign_playlist_id: campaignlist}).sum(:total) || 0
  end
  
  def detailed_info
    "#{self.name} between #{self.startdate.strftime("%d-%m-%Y")} and #{self.enddate.strftime("%d-%m-%Y")} on #{self.medium.name}" 
  end

  def productrevenue 
    campaignlist =  CampaignPlaylist.where('campaignid = ?', self.id)
   orderrevenue =  OrderMaster.where({campaign_playlist_id: campaignlist})
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
    campaignlist =  CampaignPlaylist.where('campaignid = ?', self.id)
    ordercost =  OrderMaster.where({campaign_playlist_id: campaignlist})

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

  def days
    (self.enddate - self.startdate).to_i
  end
  
  def self.import_pvt campaign_id, file, media_id, startdate, enddate, campaign_name
    total_imported = 0
    upload_campaign_errors = nil
    uploaded_campaign = Campaign.find(campaign_id)
      CSV.foreach(file.path, headers: true) do |row|
    
        campaign_playlist_hash = row.to_hash # exclude the price field
        #help_file_lists = PendingOrder.where(link: pending_order_hash["link"])
        
        yyyy = campaign_playlist_hash["yyyy"].strip if campaign_playlist_hash["yyyy"]
        mm = campaign_playlist_hash["mm"].strip if campaign_playlist_hash["mm"]
        dd = campaign_playlist_hash["dd"].strip if campaign_playlist_hash["dd"]
        start_hh = campaign_playlist_hash["start_hh"].strip if campaign_playlist_hash["start_hh"]
        start_mm = campaign_playlist_hash["start_mm"].strip if campaign_playlist_hash["start_mm"]
        end_hh = campaign_playlist_hash["end_hh"].strip if campaign_playlist_hash["end_hh"]
        end_mm = campaign_playlist_hash["end_mm"].strip if campaign_playlist_hash["end_mm"]
        product_variant_id = campaign_playlist_hash["product_variant_id"].strip if campaign_playlist_hash["product_variant_id"]
        
        mm = mm.to_s.rjust(2, '0')
        dd = dd.to_s.rjust(2, '0')
        
        for_date = "#{yyyy}-#{mm}-#{dd}"
          
        campgin_playlist = CampaignPlaylist.add_new_pvt_playlist(campaign_name, campaign_id,
        for_date, start_hh,  start_mm,  end_hh,  end_mm,  product_variant_id, media_id)
        
        total_imported += 1
          
      end # end CSV.foreach
        
      uploaded_campaign.csv_file_updated = "Imported #{total_imported} records"
      # uploaded_campaign.csv_file_errors = "#{upload_campaign_errors}"
    return uploaded_campaign 
  end # end self.import(file)
  
  
  # create_table "campaigns", force: :cascade do |t|
  #   t.string   "name"
  #   t.datetime "startdate"
  #   t.datetime "enddate"
  #   t.integer  "mediumid",      precision: 38
  #   t.text     "description"
  #   t.decimal  "cost"
  #   t.datetime "created_at"
  #   t.datetime "updated_at"
  #   t.integer  "total_cost",    precision: 38
  #   t.integer  "total_revenue", precision: 38
  # end
  
  # create_table "campaign_playlists", force: :cascade do |t|
  #   t.string   "name"
  #   t.integer  "campaignid",        precision: 38
  #   t.integer  "productvariantid",  precision: 38
  #   t.string   "filename"
  #   t.text     "description"
  #   t.decimal  "cost"
  #   t.datetime "created_at"
  #   t.datetime "updated_at"
  #   t.string   "channeltapeid"
  #   t.string   "internaltapeid"
  #   t.integer  "start_hr",          precision: 38
  #   t.integer  "start_min",         precision: 38
  #   t.integer  "start_sec",         precision: 38
  #   t.integer  "end_hr",            precision: 38
  #   t.integer  "end_min",           precision: 38
  #   t.integer  "end_sec",           precision: 38
  #   t.integer  "duration_secs",     precision: 38
  #   t.integer  "tape_id",           precision: 38
  #   t.string   "ref_name"
  #   t.integer  "list_status_id",    precision: 38
  #   t.datetime "for_date"
  #   t.integer  "total_revenue",     precision: 38
  #   t.integer  "playlist_group_id", precision: 38
  #   t.integer  "start_frame",       precision: 38
  #   t.integer  "end_frame",         precision: 38
  #   t.integer  "frames",            precision: 38
  #   t.integer  "day",               precision: 38
  #   t.decimal  "group_total_cost",  precision: 12, scale: 4
  # end
  
end
