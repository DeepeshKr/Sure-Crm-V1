class CampaignPlaylistsController < ApplicationController
 before_action { protect_controllers(8) }  
 before_action :set_campaign_playlist, only: [:show, :duplicate, :edit, :update, :groupdestroy, :destroy] #before_action :dropdown, only: [:show, :new,  :edit, :update]
 before_action :proddropdown, only: [:show, :new, :create, :update,  :edit, :update, :showproductvariant]
 before_action :set_media_tape, only: [:show, :new, :create, :update,  :edit, :update]
 before_action :activestatus, only: [:show, :new, :create, :edit, :update]

  respond_to :html

  def index
     
    if(params.has_key?(:campaignid))
      @campaign_playlists = CampaignPlaylist.where("campaignid = ?" , params[:campaignid]).order(:start_hr, :start_min, :start_sec)
        respond_to do |format|
        csv_file_name = @campaign_playlists.first.campaign.name + ".csv"
          format.html
          format.csv do
            headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
            headers['Content-Type'] ||= 'text/csv'
          end
        end
    end 
    
  end

  def perday
    medialist = Medium.where("media_group_id not in 10000")
      campaigns = Campaign.where(mediumid: medialist)

     #@showingfor
      @for_date = Time.now
    if(params.has_key?(:for_date))
      str = params[:for_date]
      newdate = Time.strptime(str, '%m/%d/%Y')

      # .where(list_status_id: 10000)
     #  .where(list_status_id: 10000).where(campaignid: campaigns)
      @campaign_playlists = CampaignPlaylist.where(for_date: newdate)
      .order(:start_hr, :start_min, :start_sec)


      @showingfor = "Schedule for " << newdate.to_formatted_s(:rfc822)
      @for_date =  newdate

    else

      #@campaign_playlists = CampaignPlaylist.all
      @campaign_playlists = CampaignPlaylist.where("for_date = ?" , Time.now.to_date)
      .where(list_status_id: 10000).where(campaignid: campaigns).order(:start_hr, :start_min, :start_sec)
      

       @showingfor = "Schedule for " << Time.now.to_date.to_formatted_s(:rfc822)
       @for_date = Time.now.to_date
    end
      respond_with(@campaign_playlists)
  end
  
def showproductvariant
 @campaign_playlist = CampaignPlaylist.find(params[:id])
  @productvariant = ProductVariant.where('activeid = ? and product_sell_type_id <= ?', 10000, 10001).order('name')
  respond_with(@campaign_playlist)

end

def updateproductvariant
   @campaign_playlist = CampaignPlaylist.find(params[:id])
if campaign_playlist_params[:productvariantid].present?
 
   @campaign_playlist.update(productvariantid: campaign_playlist_params[:productvariantid])
end

 redirect_to dailyschedule_path(:for_date => @campaign_playlist.for_date) 
end



  def show
      set_media_tape
    # @campaignlist =  Campaign.joins(:medium).where('media.telephone = ?', @order_master.calledno)
      @orderlines = OrderLine.joins(:order_master)
      .where("order_masters.campaign_playlist_id = ?", params[:id])
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
    hour_min_sec(campaign_playlist_params[:start_hr], campaign_playlist_params[:start_min],
     campaign_playlist_params[:start_sec], campaign_playlist_params[:duration_secs])
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
    #update_timings(@campaign_playlist.campaign_id)

    respond_with(@campaign_playlist.campaign)
  end
  
  def edit_individual
  @campaign_playlists = CampaignPlaylist.find(params[:campaign_playlist_ids])
  end

  def update_individual
    @campaign_playlists = CampaignPlaylist.update(params[:campaign_playlists].keys, params[:campaign_playlists].values).reject { |p| p.errors.empty? }
    if @campaign_playlists.empty?
      flash[:success] = "Campaign Playlists updated"
      respond_with(@campaign_playlists.first.campaign)
    else
      render :action => "edit_individual"
    end
  end
 
 #post insert_playlist
  def campaign_playlist_insert
   campaign_name = params[:playlist_name]
   for_date = params[:for_date]
   #for_date = for_date.strptime('%m/%d/%Y')
    campaignid = campaign_playlist_params[:campaignid]
    
    media_tapes = MediaTape.find(campaign_playlist_params[:tape_id])
     
    
           begin_hr = campaign_playlist_params[:start_hr]
           begin_min = campaign_playlist_params[:start_min]
           begin_sec = campaign_playlist_params[:start_sec]

           #media tape cost head
       
          list_status_id = 10001
                   
            hour_min_sec(begin_hr, begin_min, begin_sec, media_tapes.duration_secs)
            end_hr = @end_hr
            end_min = @end_min
            end_sec = @end_sec

     @campaign_playlist = CampaignPlaylist.create(name: media_tapes.name, 
            campaignid: campaignid, 
            start_hr: begin_hr, 
            start_min: begin_min, 
            start_sec: begin_sec, 
            ref_name: "Inserted Playlist",
            list_status_id: list_status_id,
            end_hr: end_hr, 
            end_min: end_min, 
            end_sec: end_sec,
            cost: 0, 
            channeltapeid: media_tapes.tape_ext_ref_id, 
            internaltapeid: media_tapes.unique_tape_name, 
            productvariantid: media_tapes.product_variant_id, 
            filename: media_tapes.name, 
            description: (media_tapes.description || " ") + " Inserted Playlist on " + (Date.today).to_s, 
            duration_secs: media_tapes.duration_secs, 
            tape_id: media_tapes.tape_ext_ref_id,
            for_date: for_date)

           @campaign_playlist.update(playlist_group_id: @campaign_playlist.id)
 #respond_with(@media_cost_master)
      if @campaign_playlist.valid?
          update_timings(campaignid)
          flash[:success] = "Playlist Inserted successfully added " 
           @campaign_playlist.save
          respond_with(@campaign_playlist.campaign)
      else
          flash[:error] = @campaign_playlist.errors.full_messages.join("<br/>")

          redirect_to campaigns_path(:campaign_id => campaignid)
      end
       
     

   
     #respond_with(@campaign)

  end

  #post create_duplicate_playlist
  def create_duplicate
     old_campaign_playlists = CampaignPlaylist.where(campaignid: params[:old_campaign_id])
      c_campaignid = params[:campaignid]
      old_campaign_playlists.each do |old_campaign_playlist|
                  @new_campaign_playlist = CampaignPlaylist.create(name: old_campaign_playlist.name, 
            campaignid: c_campaignid, 
            start_hr: old_campaign_playlist.start_hr, 
            start_min: old_campaign_playlist.start_min, 
            start_sec: old_campaign_playlist.start_sec, 
            ref_name: old_campaign_playlist.ref_name,
            list_status_id: old_campaign_playlist.list_status_id,
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
            tape_id: old_campaign_playlist.tape_id,
            for_date: Time.now + 1.days,
            playlist_group_id: old_campaign_playlist.playlist_group_id)
        
        end

       respond_with(@new_campaign_playlist.campaign)
  end

  def create_playlist_with_media_tape_head
    # media_tape_params params.require(:media_tape).permit(:name,:release_date, 
      #:duration_secs, :tape_ext_ref_id, :unique_tape_name, :media_id,
      # :product_variant_id, :description, :file_parts, 
    # :file_extenstion, :media_tape_head_id, :sort_order)
  media_tape_head_id = params[:media_tape_head_id]
   campaignid = params[:campaignid]
     if media_tape_head_id.present? 
        #step 1 get all the media tapes with media tape id in the same sort order
        media_tapes = MediaTape.where(media_tape_head_id: media_tape_head_id).order("sort_order ASC")
        
       # for_date =  Date.strptime(params[:for_date], "%m/%d/%Y")
        for_date =  params[:for_date]
       
        #step 2 add campaign playlist to the for the campaign id
        if media_tapes.present?
          #add media tapes to campaign playlist
          #time_slot => "auto" / "specific"
            begin_hr = params[:begin_hr]
            begin_min = params[:begin_min]
            begin_sec = params[:begin_sec]

          cost = 0
          
          first_campaign_playlist_id = 0
          
          media_tapes.each do |m|
          
            list_status_id = 10001
            if m.sort_order == 1
              list_status_id = 10000            
            end
            #ref name is combination of media tape head and media tape name
            ref_name = MediaTapeHead.find(media_tape_head_id).name 
              hour_min_sec(begin_hr, begin_min, begin_sec, m.duration_secs)
             

           new_campaign_playlist = CampaignPlaylist.create(name: m.name, 
              campaignid: campaignid, 
              start_hr: begin_hr, 
              start_min: begin_min, 
              start_sec: begin_sec, 
              ref_name: ref_name,
              list_status_id: list_status_id,
              end_hr: @end_hr, 
              end_min: @end_min, 
              end_sec: @end_sec,
              cost: cost, 
              channeltapeid: m.tape_ext_ref_id, 
              internaltapeid: m.unique_tape_name, 
              productvariantid: m.product_variant_id, 
              filename: m.name, 
              description: m.description, 
              duration_secs: m.duration_secs, 
              tape_id: m.tape_ext_ref_id,
              for_date: for_date)

            if first_campaign_playlist_id == 0
              first_campaign_playlist_id = new_campaign_playlist.id
            end

            if first_campaign_playlist_id != 0
              new_campaign_playlist.update(playlist_group_id: first_campaign_playlist_id)
            end

            begin_hr = @end_hr
            begin_min = @end_min
            begin_sec = @end_sec
          end

          flash[:success] = "Campaign Playlists updated with #{media_tapes.count()} tapes"
          #showcampaign_page(campaign_id)
          @campaign = Campaign.find(campaignid)
          respond_with(@campaign)

        else
          flash[:error] = "You cannot add anything unless you select any valid media tape list!"
          redirect_to campaigns_path(:id => campaignid)
        end

        
    else
        flash[:error] = "You cannot add anything unless you select any valid media tape list!"
        redirect_to campaigns_path(:id => campaignid)
    end
 end

 def updatecampaigntimings
   if params.has_key?(:campaignid)
    campaignid = params[:campaignid]
    update_timings(campaignid)
     @campaign = Campaign.find(campaignid)
     respond_with(@campaign)
   end
 end

#  def groupdestroy
#   if params.has_key?[:id]
#     all_grp_playlists = CampaignPlaylist.where(playlist_group_id: params[:id])

#     all_grp_playlists.each  do | grp|
#        grp.destroy
#     end
#      respond_with(@campaign_playlist.campaign)
#   end
# end
#  end
  def destroy
    #removed link
    #<%= link_to 'Destroy', campaign_playlist, method: :delete, data: { confirm: 'Are you sure?' }, class: "btn btn-info btn-xs" %>
    #@campaign_playlist.destroy
    all_grp_playlists = CampaignPlaylist.where(playlist_group_id: params[:id])

    all_grp_playlists.each  do | grp|
       grp.destroy
    end
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
        :productvariantid, :filename, :description, 
        :duration_secs, 
        :tape_id, :old_campaign_id, :ref_name, 
        :list_status_id, :for_date, :total_revenue, :playlist_group_id)
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

    def update_timings(campaign_id)
      campaigns = CampaignPlaylist.where(campaignid: campaign_id).order(:start_hr, :start_min, :start_sec)

          n_str_hr = 0
          n_str_min = 0
          n_str_sec = 0

          totalnos = 0
      campaigns.each do |c|
          #start with first or previous listing timings
          c.update(start_hr: n_str_hr, start_min: n_str_min, start_sec: n_str_sec)
          #get the ent time with start timing adding duration
          hour_min_sec(c.start_hr, c.start_min, c.start_sec, c.duration_secs)
          #update new endn timing
          c.update(end_hr: @end_hr, end_min: @end_min, end_sec: @end_sec)
           #use the end timings as start timings for the next show
           n_str_hr = @end_hr
           n_str_min = @end_min
           n_str_sec = @end_sec
           totalnos += 1
      end
      flash[:notice] = "Timings of #{totalnos} playlists were reset successfully"
    end

    def showcampaign_page(campaign_id)
      recent_campaigns
    proddropdown
      @campaign_playlists = CampaignPlaylist.where("campaignid = ?", campaign_id).order(:start_hr, :start_min, :start_sec)
       @campaign_id = params[:id]
     if @campaign.enddate >= DateTime.now
              start_hour = 0
              start_minute = 0
              start_second = 0
      if @campaign_playlists.present?
              start_hour = @campaign_playlists.last.end_hr
              start_minute = @campaign_playlists.last.end_min
              start_second = @campaign_playlists.last.end_sec
      end
       media_tapes_s = MediaTape.where("product_variant_id is null")
        
      @campaign_playlist = CampaignPlaylist.new(campaignid: params[:id],
       cost: 0, start_hr: start_hour,
       start_min: start_minute, start_sec: start_second,
       name: media_tapes_s.first.name,
       internaltapeid: media_tapes_s.first.unique_tape_name,
       filename: media_tapes_s.first.name,
       duration_secs: media_tapes_s.first.duration_secs)
     end
     
     @campaignid = params[:id]

    respond_with(@campaign, @campaign_playlists,  @campaign_playlist)
    end
end
