class CustomerOrderListsController < ApplicationController
  before_action :set_customer_order_list, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @customer_order_lists = CustomerOrderList.order("id DESC").limit(50)
    respond_with(@customer_order_lists)
  end

  def show
    respond_with(@customer_order_list)
  end

  def new
    @customer_order_list = CustomerOrderList.new
    respond_with(@customer_order_list)
  end

  def edit
  end

  def create
    @customer_order_list = CustomerOrderList.new(customer_order_list_params)
    @customer_order_list.save
    respond_with(@customer_order_list)
  end

  def update
    @customer_order_list.update(customer_order_list_params)
    respond_with(@customer_order_list)
  end

  def destroy
    @customer_order_list.destroy
    respond_with(@customer_order_list)
  end

  private
    def set_customer_order_list
      @customer_order_list = CustomerOrderList.find(params[:id])
    end

    def customer_order_list_params
      params[:customer_order_list]
    end
end
