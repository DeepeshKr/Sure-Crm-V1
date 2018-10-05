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

   @campaigns =  Campaign.where('startdate = ?', @for_date).where('mediumid = 11200')

    case a = params[:stage]
      when "old"
         @campaigns =  Campaign.where('startdate < ?', (330.minutes).from_now.to_date )
         .where('mediumid = 11200')
         @stagename = "Recent Old Campaigns"
      when "curent"
         @stagename = "All Current Campaigns"
      when "new"
         @campaigns =  Campaign.where('startdate > ? ', (330.minutes).from_now.to_date)
         .where('mediumid = 11200')
        @stagename = "All new Campaigns"
      else
        @stagename = "All Current Campaigns"
    end

    respond_with(@campaigns)
  end

  def show
    recent_campaigns
    proddropdown

    # all_campaign_playlist = CampaignPlaylist.where("day IS NULL").order("id DESC").limit(10000)
    # records = 0
    # all_campaign_playlist.each do |e|
    #   e.update(day: 0)
    #   records += 1
    # end
    #
    # flash[:notice] = "Updated of #{records} please continue till updated records become ZERO! last updated is #{all_campaign_playlist.last.id}"
    fixed_pre_paid = [10000, 10045]
    @hbn_media_total = Medium.where(media_group_id: 10000, active: true, media_commision_id: fixed_pre_paid).sum(:daily_charges)
    
    @for_date = @campaign.startdate
    @add_more = true
    @campaign_playlists = CampaignPlaylist.where("campaignid = ?", params[:id]).order(:day, :start_hr, :start_min, :start_sec)

      if params.has_key?(:only_active)
        if params[:only_active] == "true"
          @campaign_playlists = @campaign_playlists.where(list_status_id: 10000)
          @add_more = false
           @missed_for_date =  @campaign_playlists.first.for_date.strftime("%Y-%m-%d")
           #(330.minutes).from_now.for_date.strftime("%Y-%m-%d")
           # campaign_playlists/order_master_with_products
          @missed_orders = OrderMaster.where("TRUNC(orderdate) = ?", @missed_for_date)
          .where('ORDER_STATUS_MASTER_ID > 10002')
          .where("campaign_playlist_id IS NULL")
          .joins(:medium).where("media.media_group_id = 10000")


        end
      end

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
  
  def new_private_campaign
    @medialist =  Medium.where('(media_group_id IS NULL or media_group_id <> 10000) and id <> 11200').order('name')
  end
  
  def private_campaign_playlists
    if params.has_key?(:for_date)
      @for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")
      @campaigns =  Campaign.where('startdate = ?', @for_date)
      .joins(:medium).where('(media_group_id IS NULL or media_group_id <> 10000) and media.id <> 11200')
    else
      @campaigns = Campaign.joins(:medium)
      .where('(media_group_id IS NULL or media_group_id <> 10000) and media.id <> 11200')
      .order('campaigns.updated_at DESC').limit(30)
    end
    
  end
  
  def private_campaign_playlist
     @campaigns = Campaign.where(id: params[:campaign_id])
     .joins(:medium).where('(media_group_id IS NULL or media_group_id <> 10000) and media.id <> 11200')
     if @campaigns.present?
       @campaign = @campaigns.first
       @campaign_playlists = CampaignPlaylist.where(campaignid: @campaign.id)
     end
     
  end
  
  def import_pvt_playlist
    #import_pvt file, media_id, startdate, enddate, campaign_name
    import_campaign = Campaign.where(startdate: params[:startdate], mediumid: params[:mediumid])
    
    if import_campaign.blank?
      import_campaign = Campaign.create(name: params[:name], 
      startdate: params[:startdate], enddate: params[:enddate], 
      mediumid: params[:mediumid], cost: 0.0, total_cost: 0, total_revenue: 0,
      description: "Uploaded campaign playlist for #{params[:name]}")
    else
      import_campaign = import_campaign.first
    end
    
    campaign = Campaign.import_pvt(import_campaign.id, params[:file], params[:mediumid], 
    params[:startdate], params[:enddate],import_campaign.name)
  
    flash[:notice] = "#{campaign.csv_file_updated}"
    flash[:error] = "#{campaign.csv_file_errors}"
    
    redirect_to private_campaign_playlist_campaigns_path(campaign_id: campaign.id)
  end
  
  def delete_pvt_playlist
    @campaigns = Campaign.where(id: params[:campaign_id])
    .joins(:medium).where('(media_group_id IS NULL or media_group_id <> 10000) and media.id <> 11200')
    # media_group_id IS NULL or media_group_id <> 10000) and media.id <> 11200')
    if @campaigns.present?
      @campaign = Campaign.find(params[:campaign_id])
      @campaign.destroy
      @campaign_playlists = CampaignPlaylist.where(campaignid: params[:campaign_id])
      if @campaign_playlists.present?
        @campaign_playlists.each do |campaign_playlist|
          campaign_playlist.destroy
        end
      end
      flash[:notice] = "Destroyed campaign with all playlists inside"
    else
      flash[:error] = "You can only destroy Pvt Campaign and playlist here!"
    end
    redirect_to private_campaign_playlists_campaigns_path
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

  def hbn_show_all_active
    recent_campaigns
    proddropdown


    @for_date = @campaign.startdate
      @campaign_playlists = CampaignPlaylist.where("campaignid = ?", params[:id], list_status_id: 1000).order(:day, :start_hr, :start_min, :start_sec)
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
