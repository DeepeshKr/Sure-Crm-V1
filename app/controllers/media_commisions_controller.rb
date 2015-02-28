class MediaCommisionsController < ApplicationController
  before_action :set_media_commision, only: [:show, :edit, :addmedia, :addnewmedia, :update, :destroy]

  respond_to :html

  def index
    @media_commisions = MediaCommision.all
    respond_with(@media_commisions)
  end

  def show
    dropdown
    @media = Medium.where('media_commision_id = ?', params[:id])
    
    respond_with(@media_commision, @medialist, @media)
  end
  
  def addmedia
    @media = Medium.find(params[:mediumid])
    @media.update(media_commision_id: params[:id])
       
    redirect_to (@media_commision)
  end

  def new
    @media_commision = MediaCommision.new
    respond_with(@media_commision)
  end

  def edit
  end

  def create
    @media_commision = MediaCommision.new(media_commision_params)
    @media_commision.save
    respond_with(@media_commision)
  end

  def update
    @media_commision.update(media_commision_params)
    respond_with(@media_commision)
  end

  def destroy
    @media_commision.destroy
    respond_with(@media_commision)
  end

  private
    def dropdown
     @medialist = Medium.where("active = 1 and (media_group_id is null or media_group_id = ?)", params[:id] ).order('name')
     #
    end
    def set_media_commision
      @media_commision = MediaCommision.find(params[:id])
    end

    def media_commision_params
      params.require(:media_commision).permit(:name, :description)
    end
end
