class MediaController < ApplicationController
  before_action :set_medium, :dropdowns, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @media = Medium.all
    respond_with(@media)
  end

  def show
    
    respond_with(@medium)
  end

  def new
    dropdowns
    @medium = Medium.new
    respond_with(@medium)
  end

  def edit
    dropdowns
  end

  def create
    @medium = Medium.new(medium_params)
    @medium.save
    respond_with(@medium)
  end

  def update
    @medium.update(medium_params)
    respond_with(@medium)
  end

  def destroy
    @medium.destroy
    respond_with(@medium)
  end

  private
    def dropdowns
      @statelist = State.all
      @media_commission = MediaCommision.all
      @media_group = MediaGroup.all
    end
    def set_medium
      @medium = Medium.find(params[:id])
    end

    def medium_params
      params.require(:medium).permit(:name, :telephone, :alttelephone, :state, :active, 
        :corporateid, :description, :ref_name, :media_commision_id, :value, :media_group_id)
    end
end
