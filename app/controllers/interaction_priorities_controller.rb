class InteractionPrioritiesController < ApplicationController
  before_action :set_interaction_priority, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @interaction_priorities = InteractionPriority.all
    respond_with(@interaction_priorities)
  end

  def show
    respond_with(@interaction_priority)
  end

  def new
    @interaction_priority = InteractionPriority.new
    respond_with(@interaction_priority)
  end

  def edit
  end

  def create
    @interaction_priority = InteractionPriority.new(interaction_priority_params)
    @interaction_priority.save
    respond_with(@interaction_priority)
  end

  def update
    @interaction_priority.update(interaction_priority_params)
    respond_with(@interaction_priority)
  end

  def destroy
    @interaction_priority.destroy
    respond_with(@interaction_priority)
  end

  private
    def set_interaction_priority
      @interaction_priority = InteractionPriority.find(params[:id])
    end

    def interaction_priority_params
      params.require(:interaction_priority).permit(:name, :sortorder)
    end
end
