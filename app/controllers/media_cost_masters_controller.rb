class MediaCostMastersController < ApplicationController
  before_action :set_media_cost_master, only: [:show, :edit, :update, :destroy]
  before_action :dropdown, only: [:new, :edit, :destroy]

  respond_to :html

  def index
    @media_cost_masters = MediaCostMaster.all
    respond_with(@media_cost_masters)
  end

  def show
    respond_with(@media_cost_master)
  end

  def new
    @media_cost_master = MediaCostMaster.new
    respond_with(@media_cost_master)
  end

  def edit
  end

  def create
    @media_cost_master = MediaCostMaster.new(media_cost_master_params)
    @media_cost_master.save
    respond_with(@media_cost_master)
  end

  def update
    @media_cost_master.update(media_cost_master_params)
    respond_with(@media_cost_master)
  end

  def destroy
    @media_cost_master.destroy
    respond_with(@media_cost_master)
  end

  private
    def set_media_cost_master
      @media_cost_master = MediaCostMaster.find(params[:id])
    end
     def dropdown
     @medialist = Medium.where('media_commision_id = ?',  10000).order('name')
    end
    def media_cost_master_params
      params.require(:media_cost_master).permit(:name, :duration_secs, 
        :cost_per_sec, :media_id, :str_hr, :str_min,
         :str_sec, :end_hr, :end_min, :end_sec, 
         :description)
    end
end
