class OrderForsController < ApplicationController
   before_action { protect_controllers(8) } 
  before_action :set_order_for, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @order_fors = OrderFor.all
    respond_with(@order_fors)
  end

  def show
    respond_with(@order_for)
  end

  def new
    @order_for = OrderFor.new
    respond_with(@order_for)
  end

  def edit
  end

  def create
    @order_for = OrderFor.new(order_for_params)
    @order_for.save
    respond_with(@order_for)
  end

  def update
    @order_for.update(order_for_params)
    respond_with(@order_for)
  end

  def destroy
    @order_for.destroy
    respond_with(@order_for)
  end

  private
    def set_order_for
      @order_for = OrderFor.find(params[:id])
    end

    def order_for_params
      params.require(:order_for).permit(:name, :description)
    end
end
