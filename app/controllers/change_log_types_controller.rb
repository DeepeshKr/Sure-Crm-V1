class ChangeLogTypesController < ApplicationController
  before_action :set_change_log_type, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @change_log_types = ChangeLogType.all
    respond_with(@change_log_types)
  end

  def show
    respond_with(@change_log_type)
  end

  def new
    @change_log_type = ChangeLogType.new
    respond_with(@change_log_type)
  end

  def edit
  end

  def create
    @change_log_type = ChangeLogType.new(change_log_type_params)
    @change_log_type.save
    respond_with(@change_log_type)
  end

  def update
    @change_log_type.update(change_log_type_params)
    respond_with(@change_log_type)
  end

  def destroy
    @change_log_type.destroy
    respond_with(@change_log_type)
  end

  private
    def set_change_log_type
      @change_log_type = ChangeLogType.find(params[:id])
    end

    def change_log_type_params
      params.require(:change_log_type).permit(:name, :description)
    end
end
