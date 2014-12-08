class AddressValidsController < ApplicationController
  before_action :set_address_valid, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @address_valids = AddressValid.all
    respond_with(@address_valids)
  end

  def show
    respond_with(@address_valid)
  end

  def new
    @address_valid = AddressValid.new
    respond_with(@address_valid)
  end

  def edit
  end

  def create
    @address_valid = AddressValid.new(address_valid_params)
    @address_valid.save
    respond_with(@address_valid)
  end

  def update
    @address_valid.update(address_valid_params)
    respond_with(@address_valid)
  end

  def destroy
    @address_valid.destroy
    respond_with(@address_valid)
  end

  private
    def set_address_valid
      @address_valid = AddressValid.find(params[:id])
    end

    def address_valid_params
      params.require(:address_valid).permit(:name)
    end
end
