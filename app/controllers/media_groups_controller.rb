class MediaGroupsController < ApplicationController
  before_action :set_media_group, only: [:show, :edit, :addmedia, :update, :destroy]

  respond_to :html

  def index
    @media_groups = MediaGroup.all
    respond_with(@media_groups)
  end

  def show
   @url = request.original_url
    dropdown
    @media = Medium.where('media_group_id = ?', params[:id])


    campaignlist = Campaign.where({mediumid: @media})
    @campaigns =  campaignlist.where('startdate <= ? and enddate >= ?', DateTime.now, DateTime.now )
     @stagename = "All Current Campaigns"
    # if params.has_key?[:stage]
        case a = params[:stage]
          when "old"
             @campaigns =  campaignlist.where('enddate <= ?', DateTime.now )
               @stagename = "Recent Old Campaigns"
          when "curent"
             @stagename = "All Current Campaigns"
          when "new"
             @campaigns =  campaignlist.where('startdate >= ? ', DateTime.now)
            @stagename = "All new Campaigns"
          else
            @stagename = "All Current Campaigns"
        end
    # end
    respond_with(@media_group, @medialist, @media, @campaign)
  end

  def addmedia
    @media = Medium.find(params[:mediumid])
    @media.update(media_group_id: params[:id])
       
    redirect_to (@media_group)
  end

  def new
    @media_group = MediaGroup.new
    respond_with(@media_group)
  end

  def edit
  end

  def create
    @media_group = MediaGroup.new(media_group_params)
    @media_group.save
    respond_with(@media_group)
  end

  def update
    @media_group.update(media_group_params)
    respond_with(@media_group)
  end

  def destroy
    @media_group.destroy
    respond_with(@media_group)
  end

  private
    def dropdown
     @medialist = Medium.where("active = true and (media_group_id is null or media_group_id <> ?)", params[:id]).order('name')
     #.where.not(media_group_id: params[:id])
     #and media_group_id = ?", params[:id]
    end
    def set_media_group
      @media_group = MediaGroup.find(params[:id])
    end

    def media_group_params
      params.require(:media_group).permit(:name, :description, :stage)
    end
end
