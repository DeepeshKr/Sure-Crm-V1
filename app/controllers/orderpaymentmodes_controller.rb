class OrderpaymentmodesController < ApplicationController
   before_action { protect_controllers(6) } 
  before_action :set_orderpaymentmode, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @orderpaymentmodes = Orderpaymentmode.all
    respond_with(@orderpaymentmodes)
  end

  def show
    respond_with(@orderpaymentmode)
  end

  def new
    @orderpaymentmode = Orderpaymentmode.new
    respond_with(@orderpaymentmode)
  end

  def edit
  end

  def create
    @orderpaymentmode = Orderpaymentmode.new(orderpaymentmode_params)
    @orderpaymentmode.save
    respond_with(@orderpaymentmode)
  end

  def update
    @orderpaymentmode.update(orderpaymentmode_params)
    respond_with(@orderpaymentmode)
  end

  def destroy
    @orderpaymentmode.destroy
    respond_with(@orderpaymentmode)
  end

  private
    def set_orderpaymentmode
      @orderpaymentmode = Orderpaymentmode.find(params[:id])
    end

    def orderpaymentmode_params
      params.require(:orderpaymentmode).permit(:name, :description, :charges, :payment_cost, 
      :is_valid, :hold_hours)
    end
end
