class CampaignPlayListStatusesController < ApplicationController
  before_action :set_campaign_play_list_status, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @campaign_play_list_statuses = CampaignPlayListStatus.all
    respond_with(@campaign_play_list_statuses)
  end

  def show
    respond_with(@campaign_play_list_status)
  end

  def new
    @campaign_play_list_status = CampaignPlayListStatus.new
    respond_with(@campaign_play_list_status)
  end

  def edit
  end

  def create
    @campaign_play_list_status = CampaignPlayListStatus.new(campaign_play_list_status_params)
    @campaign_play_list_status.save
    respond_with(@campaign_play_list_status)
  end

  def update
    @campaign_play_list_status.update(campaign_play_list_status_params)
    respond_with(@campaign_play_list_status)
  end

  def destroy
    @campaign_play_list_status.destroy
    respond_with(@campaign_play_list_status)
  end

  private
    def set_campaign_play_list_status
      @campaign_play_list_status = CampaignPlayListStatus.find(params[:id])
    end

    def campaign_play_list_status_params
      params.require(:campaign_play_list_status).permit(:name, :description)
    end
end
