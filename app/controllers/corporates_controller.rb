class CorporatesController < ApplicationController
  before_action :set_corporate, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @corporates = Corporate.all
    respond_with(@corporates)
  end

  def show
    respond_with(@corporate)
  end

  def new
    @corporate = Corporate.new
    respond_with(@corporate)
  end

  def edit
  end

  def create
    @corporate = Corporate.new(corporate_params)
    @corporate.save
    respond_with(@corporate)
  end

  def update
    @corporate.update(corporate_params)
    respond_with(@corporate)
  end

  def destroy
    @corporate.destroy
    respond_with(@corporate)
  end

  private
    def set_corporate
      @corporate = Corporate.find(params[:id])
    end

    def corporate_params
      params.require(:corporate).permit(:name, :address1, :address2, :address3, :landmark, :city, :pincode, :state, :district, :country, :telephone1, :telephone2, :fax, :website, :salute1, :first_name1, :last_name1, :designation1, :mobile1, :emaild1, :salute2, :first_name2, :last_name2, :designation2, :mobile2, :emailid2, :salute3, :first_name3, :last_name3, :designation3, :mobile3, :emailid3, :description)
    end
end
