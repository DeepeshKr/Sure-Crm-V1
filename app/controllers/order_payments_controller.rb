class OrderPaymentsController < ApplicationController
   before_action { protect_controllers(6) } 
  before_action :set_order_payment, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @order_payments = OrderPayment.all
    respond_with(@order_payments)
  end

  def show
    respond_with(@order_payment)
  end

  def new
    @order_payment = OrderPayment.new
    respond_with(@order_payment)
  end

  def edit
  end

  def create
    @order_payment = OrderPayment.new(order_payment_params)
    @order_payment.save
    respond_with(@order_payment)
  end

  def update
    @order_payment.update(order_payment_params)
    respond_with(@order_payment)
  end

  def destroy
    @order_payment.destroy
    respond_with(@order_payment)
  end

  private
    def set_order_payment
      @order_payment = OrderPayment.find(params[:id])
    end

    def order_payment_params
      params.require(:order_payment).permit(:order_master_id, :ref_no, :orderpaymentmode_id, :paid_date, :name, :description)
    end
end
