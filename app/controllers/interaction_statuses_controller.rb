class InteractionStatusesController < ApplicationController
   before_action { protect_controllers(8) } 
  before_action :set_interaction_status, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @interaction_statuses = InteractionStatus.all
    respond_with(@interaction_statuses)
  end

  def show
    respond_with(@interaction_status)
  end

  def new
    @interaction_status = InteractionStatus.new
    respond_with(@interaction_status)
  end

  def edit
  end

  def create
    @interaction_status = InteractionStatus.new(interaction_status_params)
    @interaction_status.save
    respond_with(@interaction_status)
  end

  def update
    @interaction_status.update(interaction_status_params)
    respond_with(@interaction_status)
  end

  def destroy
    @interaction_status.destroy
    respond_with(@interaction_status)
  end

  private
    def set_interaction_status
      @interaction_status = InteractionStatus.find(params[:id])
    end

    def interaction_status_params
      params.require(:interaction_status).permit(:customer_description, :internal_description, :sortorder)
    end
end
