class CampaignPlaylistsController < ApplicationController
  before_action :set_campaign_playlist, only: [:show, :duplicate, :edit, :update, :destroy]
 #before_action :dropdown, only: [:show, :new,  :edit, :update]
 before_action :proddropdown, only: [:show, :new, :create, :update,  :edit, :update]
 before_action :set_media_tape, only: [:show, :new, :create, :update,  :edit, :update]
 before_action :activestatus, only: [:show, :new, :create, :edit, :update]

  respond_to :html

  def index
     
    if(params.has_key?(:campaignid))
      @campaign_playlists = CampaignPlaylist.where("campaignid = ?" , params[:campaignid]).order(:start_hr, :start_min, :start_sec)
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
    set_media_tape
  # @campaignlist =  Campaign.joins(:medium).where('media.telephone = ?', @order_master.calledno)
    @orderlines = OrderLine.joins(:order_master).where("order_masters.campaign_playlist_id = ?", params[:id])
# Parent.joins(:children).where(children:{favorite:true})
    respond_with(@campaign_playlist, @orderlines)
  end

  def new
    set_media_tape
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
    set_media_tape
    #tape_id to find end time duration secs, internaltapeid:, filename, name
    #:end_hr, :end_min, :end_sec, from duration_secs
    @campaign_playlist = CampaignPlaylist.new(campaign_playlist_params)
    hour_min_sec(campaign_playlist_params[:start_hr], campaign_playlist_params[:start_min], campaign_playlist_params[:start_sec], campaign_playlist_params[:duration_secs])
     @campaign_playlist.end_hr = @end_hr
     @campaign_playlist.end_min = @end_min
     @campaign_playlist.end_sec = @end_sec

 
    if @campaign_playlist.valid?
      flash[:success] = "Playlist was added successfully." 
        @campaign_playlist.save
        respond_with(@campaign_playlist.campaign)
    else
      flash[:error] = @campaign_playlist.errors.full_messages.join("<br>")
      respond_with(@campaign_playlist)
    end

  end

  def update
    set_media_tape
    if campaign_playlist_params[:cost].to_f != @campaign_playlist.cost
      @campaign_playlist.campaign.update(cost: @campaign_playlist.campaign.cost + @campaign_playlist.cost - campaign_playlist_params[:cost].to_f)
    end
    
    @campaign_playlist.campaign.update(cost: CampaignPlaylist.where(:campaignid => campaign_playlist_params[:campaignid]).sum(:cost))
    
    @campaign_playlist.update(campaign_playlist_params)
    #reset timings  
    #update(@campaign_playlist.campaign_id)

    respond_with(@campaign_playlist.campaign)
  end
  
 
  #post create_duplicate_playlist
  def create_duplicate
     old_campaign_playlist = CampaignPlaylist.find(params[:old_campaign_id])
      c_campaignid = params[:campaignid]
      @new_campaign_playlist = CampaignPlaylist.create(name: old_campaign_playlist.name, 
        campaignid: c_campaignid, 
        start_hr: old_campaign_playlist.start_hr, 
        start_min: old_campaign_playlist.start_min, 
        start_sec: old_campaign_playlist.start_sec, 
        end_hr: old_campaign_playlist.end_hr, 
        end_min: old_campaign_playlist.end_min, 
        end_sec: old_campaign_playlist.end_sec,
        cost: old_campaign_playlist.cost, 
        channeltapeid: old_campaign_playlist.channeltapeid, 
        internaltapeid: old_campaign_playlist.internaltapeid, 
        productvariantid: old_campaign_playlist.productvariantid, 
        filename: old_campaign_playlist.filename, 
        description: old_campaign_playlist.description, 
        duration_secs: old_campaign_playlist.duration_secs, 
        tape_id: old_campaign_playlist.tape_id)

       respond_with(@new_campaign_playlist.campaign)
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
    def activestatus
     @active_status = CampaignPlayListStatus.all.order('id')
    end
     def proddropdown
     @productvariant = ProductVariant.where('activeid = 10000').order('name')
    end
    def campaign_playlist_params
      params.require(:campaign_playlist).permit(:name, :campaignid, 
        :start_hr, :start_min, :start_sec, 
        :end_hr, :end_min, :end_sec,
        :cost, :channeltapeid, :internaltapeid, 
        :productvariantid, :filename, :description, :duration_secs, 
        :tape_id, :old_campaign_id, :ref_name, :list_status_id)
    end
    def set_media_tape
      @media_tapes = MediaTape.all
    end

    def hour_min_sec(s_hr, s_min, s_sec, duration_seconds)
         first = (s_hr.to_i * 60 * 60) + (s_min.to_i * 60) + s_sec.to_i
         
        totalseconds = duration_seconds.to_i + first
        @end_sec    =  totalseconds % 60
        totalseconds = (totalseconds - @end_sec) / 60
        @end_min    =  totalseconds % 60
        totalseconds = (totalseconds - @end_min) / 60
        @end_hr      =  totalseconds % 24
    end

    # def recent_campaigns
    #   @recentplaylist = Campaigns.where("mediumid = ?", @campaign_playlist.campaigns.mediumid).order('id DESC').limit(10)
    # end

    def update(campaign_id)
      campaigns = CampaignPlaylist.where(campaignid: campaign_id).order(:start_hr, :start_min, :start_sec)

          n_str_hr = campaigns.first.start_hr
          n_str_min = campaigns.first.start_min
          n_str_sec = campaigns.first.start_sec

      campaigns.each do |c|
            
          hour_min_sec(c.start_hr, c.start_min, c.start_sec, c.duration_secs)
          campaign_playlist.update(start_hr: n_str_hr, start_min: n_str_min, start_sec: n_str_sec)
          campaign_playlist.update(end_hr: @end_hr, end_min: @end_min, end_sec: @end_sec)

           n_str_hr = @end_hr
           n_str_min = @end_min
           n_str_sec = @end_sec

      end
    end
end
