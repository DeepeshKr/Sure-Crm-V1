class OrderStatusMastersController < ApplicationController
   before_action { protect_controllers(6) } 
  before_action :set_order_status_master, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @order_status_masters = OrderStatusMaster.all.order(:sortorder)
    respond_with(@order_status_masters)
  end

  def show
    @order_masters = OrderMaster.where(order_status_master_id: params[:id])
    respond_with(@order_status_master, @order_masters)
  end

  def new
    @order_status_master = OrderStatusMaster.new
    respond_with(@order_status_master)
  end

  def edit
  end

  def create
    @order_status_master = OrderStatusMaster.new(order_status_master_params)
    @order_status_master.save
    respond_with(@order_status_master)
  end

  def update
    @order_status_master.update(order_status_master_params)
    respond_with(@order_status_master)
  end

  def destroy
    @order_status_master.destroy
    respond_with(@order_status_master)
  end

  private
    def set_order_status_master
      @order_status_master = OrderStatusMaster.find(params[:id])
    end

    def order_status_master_params
      params.require(:order_status_master).permit(:name, :sortorder)
    end
end
