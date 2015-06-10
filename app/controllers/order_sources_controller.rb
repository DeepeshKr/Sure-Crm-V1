class OrderSourcesController < ApplicationController
   before_action { protect_controllers(7) } 
  before_action :set_order_source, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @order_sources = OrderSource.all
    respond_with(@order_sources)
  end

  def show
    respond_with(@order_source)
  end

  def new
    @order_source = OrderSource.new
    respond_with(@order_source)
  end

  def edit
  end

  def create
    @order_source = OrderSource.new(order_source_params)
    @order_source.save
    respond_with(@order_source)
  end

  def update
    @order_source.update(order_source_params)
    respond_with(@order_source)
  end

  def destroy
    @order_source.destroy
    respond_with(@order_source)
  end

  private
    def set_order_source
      @order_source = OrderSource.find(params[:id])
    end

    def order_source_params
      params.require(:order_source).permit(:name)
    end
end
