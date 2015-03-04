class CampaignsController < ApplicationController
  before_action :set_campaign, only: [:show,  :edit, :update, :destroy]
  before_action :dropdown, only: [:show, :new, :edit, :update]
  before_action :proddropdown, only: [:show, :new, :edit, :update, :destroy]
  respond_to :html

  def index
    #@campaigns = Campaign.all
     @campaigns =  Campaign.where('startdate <= ? and enddate >= ?', DateTime.now, DateTime.now )
    case a = params[:stage]
      when "old"
         @campaigns =  Campaign.where('enddate <= ?', DateTime.now )
           @stagename = "Recent Old Campaigns"
      when "curent"
         @stagename = "All Current Campaigns"
      when "new"
         @campaigns =  Campaign.where('startdate >= ? ', DateTime.now)
        @stagename = "All new Campaigns"
      else
        @stagename = "All Current Campaigns"
    end

   # if params.has_key?[:media]
   #  case a = params[:media]


   # end

    respond_with(@campaigns)
  end

  def show
      @campaign_playlists = CampaignPlaylist.where("campaignid = ?", params[:id]).order(:start_hr, :start_min, :start_sec)
       @campaign_id = params[:id]
     if @campaign.enddate >= DateTime.now
      @campaign_playlist = CampaignPlaylist.new(campaignid: params[:id])
     end
    respond_with(@campaign, @campaign_playlists,  @campaign_playlist)
  end

  def new 
    @campaign = Campaign.new
     @campaign.cost = 0
    respond_with(@campaign)
  end

  def edit
  end

  def create
    @campaign = Campaign.new(campaign_params)
    #@campaign.cost = 0
    @campaign.save
    respond_with(@campaign)
  end

  def update
    @campaign.update(campaign_params)
    respond_with(@campaign)
  end

  def destroy
    @campaign.destroy
    respond_with(@campaign)
  end

  private
    def dropdown
     @medialist = Medium.where('media_commision_id = ?',  10000).order('name')
    end
     def proddropdown
     @productvariant = ProductVariant.where('activeid = 10000').order('name')
    end
    def set_campaign
      @campaign = Campaign.find(params[:id])
    end

    def campaign_params
      params.require(:campaign).permit(:name, :startdate, :enddate, :mediumid, :description, :campaignstageid, :stage, :media)
    end
end
