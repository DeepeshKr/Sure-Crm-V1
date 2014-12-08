class OrderLineDispatchStatusesController < ApplicationController
  before_action :set_order_line_dispatch_status, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @order_line_dispatch_statuses = OrderLineDispatchStatus.all
    respond_with(@order_line_dispatch_statuses)
  end

  def show
    respond_with(@order_line_dispatch_status)
  end

  def new
    @order_line_dispatch_status = OrderLineDispatchStatus.new
    respond_with(@order_line_dispatch_status)
  end

  def edit
  end

  def create
    @order_line_dispatch_status = OrderLineDispatchStatus.new(order_line_dispatch_status_params)
    @order_line_dispatch_status.save
    respond_with(@order_line_dispatch_status)
  end

  def update
    @order_line_dispatch_status.update(order_line_dispatch_status_params)
    respond_with(@order_line_dispatch_status)
  end

  def destroy
    @order_line_dispatch_status.destroy
    respond_with(@order_line_dispatch_status)
  end

  private
    def set_order_line_dispatch_status
      @order_line_dispatch_status = OrderLineDispatchStatus.find(params[:id])
    end

    def order_line_dispatch_status_params
      params.require(:order_line_dispatch_status).permit(:name, :sortorder)
    end
end
