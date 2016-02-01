class CampaignsController < ApplicationController
  before_action { protect_controllers(8) }
  before_action :set_campaign, only: [:show,  :edit, :update, :destroy]
  before_action :dropdown, only: [:show, :new, :edit, :create, :update]
  before_action :proddropdown, only: [:show, :new, :edit, :create, :update, :destroy]
  before_action :set_media_tape, only: [:show, :new, :create, :edit, :update]
  before_action :activestatus, only: [:show, :new, :create, :edit, :update]

  respond_to :html

  def index
    #@campaigns = Campaign.all
    @for_date = (330.minutes).from_now.to_date.strftime("%Y-%m-%d")

    if params.has_key?(:for_date)
     @for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")
    end

   @showing_for_date = "Showing campaigns for date #{@for_date}"

   @campaigns =  Campaign.where('startdate = ?', @for_date)

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

    all_campaign_playlist = CampaignPlaylist.where("day IS NULL").order("id DESC").limit(1000)
    records = 0
    all_campaign_playlist.each do |e|
      e.update(day: 0)
      records += 1
    end

    flash[:notice] = "Updated of #{records} please continue till updated records become ZERO!"

    @for_date = @campaign.startdate
      @campaign_playlists = CampaignPlaylist.where("campaignid = ?", params[:id]).order(:day, :start_hr, :start_min, :start_sec)
       @campaign_id = params[:id]

              @begin_hr = 0
              @begin_min = 0
              @begin_sec = 0
              @begin_frame = 0
               @day = 0
        if @campaign_playlists.present?
                @begin_hr = @campaign_playlists.last.end_hr
                @begin_min = @campaign_playlists.last.end_min
                @begin_sec = @campaign_playlists.last.end_sec
                @begin_frame = @campaign_playlists.last.frames
                 @day = @campaign_playlists.last.day
        end

         # #remove after testing
         # @campaign_playlist = CampaignPlaylist.new(campaignid: params[:id],
         # cost: 0, start_hr: @begin_hr,
         # start_min: @begin_min, start_sec: @begin_sec)

     #if @campaign.startdate > (330.minutes).from_now.to_date
         @campaign_playlist = CampaignPlaylist.new(campaignid: params[:id],
         cost: 0,
         start_hr: @begin_hr,
         start_min: @begin_min,
         start_sec: @begin_sec,
         start_frame: @begin_frame)
     #end

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
    #  #allow edit only for date more than today
    #  @llowedit = 0
    #  if @campaign.startdate > (330.minutes).from_now.to_date
    #   @allowedit = 1
    # end
    # respond_with(@campaign, @campaign_playlists,  @campaign_playlist)
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

     @media_cost_master = MediaCostMaster.where("media_id <> 11200").order(:total_cost)
     @hbn_media_cost_master = MediaCostMaster.where(media_id: 11200).order(:total_cost)

    end
     def proddropdown
      #product_sell_type_id
     @productvariant = ProductVariant.where('activeid = ? and product_sell_type_id <= ?', 10000, 10001).order('name')

     #@media_cost_masters
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
