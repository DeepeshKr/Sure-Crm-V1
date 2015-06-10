class ChangeLogTrailsController < ApplicationController
   before_action { protect_controllers(8) } 
  before_action :set_change_log_trail, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @change_log_trails = ChangeLogTrail.all
    respond_with(@change_log_trails)
  end

  def show
    respond_with(@change_log_trail)
  end

  def new
    @change_log_trail = ChangeLogTrail.new
    respond_with(@change_log_trail)
  end

  def edit
  end

  def create
    @change_log_trail = ChangeLogTrail.new(change_log_trail_params)
    @change_log_trail.save
    respond_with(@change_log_trail)
  end

  def update
    @change_log_trail.update(change_log_trail_params)
    respond_with(@change_log_trail)
  end

  def destroy
    @change_log_trail.destroy
    respond_with(@change_log_trail)
  end

  private
    def set_change_log_trail
      @change_log_trail = ChangeLogTrail.find(params[:id])
    end

    def change_log_trail_params
      params.require(:change_log_trail).permit(:changelogtype_id, :refid, :name, :description, :username, :ip)
    end
end
