class AddressTypesController < ApplicationController
  before_action :set_address_type, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @address_types = AddressType.all
    respond_with(@address_types)
  end

  def show
    respond_with(@address_type)
  end

  def new
    @address_type = AddressType.new
    respond_with(@address_type)
  end

  def edit
  end

  def create
    @address_type = AddressType.new(address_type_params)
    @address_type.save
    respond_with(@address_type)
  end

  def update
    @address_type.update(address_type_params)
    respond_with(@address_type)
  end

  def destroy
    @address_type.destroy
    respond_with(@address_type)
  end

  private
    def set_address_type
      @address_type = AddressType.find(params[:id])
    end

    def address_type_params
      params.require(:address_type).permit(:name)
    end
end
