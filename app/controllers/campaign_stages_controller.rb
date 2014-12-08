class CampaignStagesController < ApplicationController
  before_action :set_campaign_stage, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @campaign_stages = CampaignStage.all
    respond_with(@campaign_stages)
  end

  def show
    respond_with(@campaign_stage)
  end

  def new
    @campaign_stage = CampaignStage.new
    respond_with(@campaign_stage)
  end

  def edit
  end

  def create
    @campaign_stage = CampaignStage.new(campaign_stage_params)
    @campaign_stage.save
    respond_with(@campaign_stage)
  end

  def update
    @campaign_stage.update(campaign_stage_params)
    respond_with(@campaign_stage)
  end

  def destroy
    @campaign_stage.destroy
    respond_with(@campaign_stage)
  end

  private
    def set_campaign_stage
      @campaign_stage = CampaignStage.find(params[:id])
    end

    def campaign_stage_params
      params.require(:campaign_stage).permit(:name, :sortorder)
    end
end
