class CampaignPlaylistsController < ApplicationController
  before_action :set_campaign_playlist, only: [:show, :edit, :update, :destroy]
 #before_action :dropdown, only: [:show, :new,  :edit, :update]
 before_action :proddropdown, only: [:show, :new,  :edit, :update]

  respond_to :html

  def index
    
    if(params.has_key?(:campaignid))
      @campaign_playlists = CampaignPlaylist.where("campaignid = ?" , params[:campaignid]).order(:start_hr, :start_min, :start_sec)
    #respond_with(@campaign_playlists)
    # elsif
    #   @campaign_playlists = CampaignPlaylist.all
    # respond_with(@campaign_playlists)
      respond_to do |format|
          format.html
          format.csv do
            headers['Content-Disposition'] = "attachment; filename=\"campaign-playlist\""
            headers['Content-Type'] ||= 'text/csv'
          end
      end
    end
    
  end

  
  def show
  # @campaignlist =  Campaign.joins(:medium).where('media.telephone = ?', @order_master.calledno)
    @orderlines = OrderLine.joins(:order_master).where("order_masters.campaign_playlist_id = ?", params[:id])
# Parent.joins(:children).where(children:{favorite:true})
    respond_with(@campaign_playlist, @orderlines)
  end

  def new
     if(params.has_key?(:campaignid))
        @campaign_playlist = CampaignPlaylist.new
        @campaign_playlist.campaignid = params[:campaignid]
        @campaign_playlist.cost = 0
    respond_with(@campaign_playlist)
     elsif
        @campaign_playlist = CampaignPlaylist.new
         @campaign_playlist.cost = 0
    respond_with(@campaign_playlist)
     end
     
   
  end

  def edit
  end

  def create
    @campaign_playlist = CampaignPlaylist.new(campaign_playlist_params)
    @campaign_playlist.save
     
    # _cost = @campaign_playlist.cost || 0

    #@campaign_playlist.campaign.update(cost: @campaign_playlist.campaign.cost + _cost)
    
    respond_with(@campaign_playlist.campaign)
   # respond_with(@campaign_playlist)
  end

  def update
    if campaign_playlist_params[:cost].to_f != @campaign_playlist.cost
      @campaign_playlist.campaign.update(cost: @campaign_playlist.campaign.cost + @campaign_playlist.cost - campaign_playlist_params[:cost].to_f)
    end
    
    @campaign_playlist.campaign.update(cost: CampaignPlaylist.where(:campaignid => campaign_playlist_params[:campaignid]).sum(:cost))
    
    @campaign_playlist.update(campaign_playlist_params) 
    
    respond_with(@campaign_playlist.campaign)
  end

  def destroy
    @campaign_playlist.destroy
    respond_with(@campaign_playlist.campaign)
  end

  private
    def set_campaign_playlist
      @campaign_playlist = CampaignPlaylist.find(params[:id])
    end
    def dropdown
     @medialist = Medium.where('media_commision_id = ?',  10000).order('name')
    end
     def proddropdown
     @productvariant = ProductVariant.where('activeid = 10000').order('name')
    end
    def campaign_playlist_params
      params.require(:campaign_playlist).permit(:name, :campaignid, 
        :start_hr, :start_min, :start_sec, 
        :end_hr, :end_min, :end_sec,
        :endtime, :cost,:channeltapeid, :internaltapeid, :productvariantid, :filename, :description)
    end
end

