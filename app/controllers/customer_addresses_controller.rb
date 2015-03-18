class CustomerAddressesController < ApplicationController
  before_action :set_customer_address, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @customer_addresses = CustomerAddress.all.order("id")
    respond_with(@customer_addresses)
  end

  def show
    respond_with(@customer_address)
  end

  def new
    @customer_address = CustomerAddress.new
    respond_with(@customer_address)
  end

  def edit
  end

  def create
    @customer_address = CustomerAddress.new(customer_address_params)
    @customer_address.save
    respond_with(@customer_address)
  end

  def update
    @customer_address.update(customer_address_params)
    respond_with(@customer_address)
  end

  def destroy
    @customer_address.destroy
    respond_with(@customer_address)
  end

  private
    def set_customer_address
      @customer_address = CustomerAddress.find(params[:id])
    end

    def customer_address_params
      params.require(:customer_address).permit(:customer_id, :name, 
        :address1, :address2, :address3, :landmark, 
        :city, :pincode, :state, :district, :country, 
        :telephone1, :telephone2, :fax, :description, :valid_id)
    end
end
