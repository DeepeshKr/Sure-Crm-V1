class CampaignsController < ApplicationController
  before_action :set_campaign, only: [:show,  :edit, :update, :destroy]
  before_action :dropdown, only: [:show, :new, :edit, :create, :update]
  before_action :proddropdown, only: [:show, :new, :edit, :create, :update, :destroy]
  before_action :set_media_tape, only: [:show, :new, :create, :edit, :update]
  before_action :activestatus, only: [:show, :new, :create, :edit, :update]

  respond_to :html

  def index
    #@campaigns = Campaign.all
    for_date = (330.minutes).from_now.to_date

    if params.has_key?(:for_date)
     for_date =  Date.strptime(params[:for_date], "%m/%d/%Y")
    end
   
   @showing_for_date = "Showing campaigns for date #{for_date}"
   
   @campaigns =  Campaign.where('startdate = ?', for_date)

    case a = params[:stage]
      when "old"
         @campaigns =  Campaign.where('startdate < ?', (330.minutes).from_now.to_date )
         @stagename = "Recent Old Campaigns"
      when "curent"
         @stagename = "All Current Campaigns"
      when "new"
         @campaigns =  Campaign.where('startdate > ? ', (330.minutes).from_now.to_date)
        @stagename = "All new Campaigns"
      else
        @stagename = "All Current Campaigns"
    end
    
    respond_with(@campaigns)
  end

  def show
    recent_campaigns
    proddropdown
   
    
    @for_date = @campaign.startdate
      @campaign_playlists = CampaignPlaylist.where("campaignid = ?", params[:id]).order(:start_hr, :start_min, :start_sec)
       @campaign_id = params[:id]
     if @campaign.startdate > (330.minutes).from_now.to_date
              start_hour = 0
              start_minute = 0
              start_second = 0
        if @campaign_playlists.present?
                start_hour = @campaign_playlists.last.end_hr
                start_minute = @campaign_playlists.last.end_min
                start_second = @campaign_playlists.last.end_sec
        end
       #media_tapes_s = MediaTape.where("product_variant_id is null")
      # name: media_tapes_s.first.name,
       # internaltapeid: media_tapes_s.first.unique_tape_name,
       # filename: media_tapes_s.first.name,
       # duration_secs: media_tapes_s.first.duration_secs

        @campaign_playlist = CampaignPlaylist.new(campaignid: params[:id],
         cost: 0, start_hr: start_hour,
         start_min: start_minute, start_sec: start_second)
     end
     
     @campaignid = params[:id]
     #check if media belongs to HBN Group
     media_check = Medium.find(@campaign.mediumid)
     if media_check.media_group_id == 10000
        @hbnchecked = true
        @pvtchannelchecked = false
        @media_name = "HBN"


     else
        @hbnchecked = false
        @pvtchannelchecked = true
        @media_name = "Pvt Channel"
     end
     #allow edit only for date more than today
     @llowedit = 0
     if @campaign.startdate > (330.minutes).from_now.to_date
      @allowedit = 1
    end

   

    respond_with(@campaign, @campaign_playlists,  @campaign_playlist)
  end
 
  def new 
    proddropdown
    @campaign = Campaign.new
    @campaign.cost = 0
    respond_with(@campaign)
  end

  def edit
  end

  def create
    proddropdown
    campaign_params[:enddate] = campaign_params[:startdate]
    @campaign = Campaign.new(campaign_params)
    #@campaign.cost = 0
    @campaign.save
     if Medium.find(@campaign.mediumid).daily_charges.present?
      campaign_cost = Medium.find(@campaign.mediumid).daily_charges
      @Campaign.update(total_cost: campaign_cost)
    end
    respond_with(@campaign)
  end

  def update
    if Medium.find(@campaign.mediumid).daily_charges.present?
      campaign_cost = Medium.find(@campaign.mediumid).daily_charges
      @Campaign.update(total_cost: campaign_cost)
    end
    @campaign.update(campaign_params)
    respond_with(@campaign)
  end

  def destroy
    @campaign.destroy
    respond_with(@campaign)
  end

  private 
    def dropdown
     @medialist = Medium.where('media_commision_id = ?',  10000).where('media_group_id IS NULL or media_group_id <> 10000 or id = 11200').order('name')
     @media_tape_head_list = MediaTapeHead.take(0)
     @productvariantlist = ProductVariant.where('product_variants.activeid = ? and product_variants.product_sell_type_id < ?', 10000, 10002).joins(:product_master)
     .where("product_masters.productactivecodeid = ?", 10000).order("product_variants.name")

     @media_cost_master = MediaCostMaster.all
    end
     def proddropdown
      #product_sell_type_id
     @productvariant = ProductVariant.where('activeid = ? and product_sell_type_id <= ?', 10000, 10001).order('name')
    end 
     def activestatus
     @active_status = CampaignPlayListStatus.all.order('id')
    end
    def set_campaign
      @campaign = Campaign.find(params[:id])
    end

    def recent_campaigns
      @recentplaylist = Campaign.order('id DESC').limit(30)
    end

    def campaign_params
      params.require(:campaign).permit(:name, :startdate, :enddate, :mediumid, 
        :description, :campaignstageid, :stage, :media,:total_cost, :total_revenue)
    end
    def set_media_tape
      @media_tapes = MediaTape.where('product_variant_id is null')
    end
end
