class CorporateTypesController < ApplicationController
   before_action { protect_controllers(8) } 
  before_action :set_corporate_type, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @corporate_types = CorporateType.all
    respond_with(@corporate_types)
  end

  def show
    respond_with(@corporate_type)
  end

  def new
    @corporate_type = CorporateType.new
    respond_with(@corporate_type)
  end

  def edit
  end

  def create
    @corporate_type = CorporateType.new(corporate_type_params)
    @corporate_type.save
    respond_with(@corporate_type)
  end

  def update
    @corporate_type.update(corporate_type_params)
    respond_with(@corporate_type)
  end

  def destroy
    @corporate_type.destroy
    respond_with(@corporate_type)
  end

  private
    def set_corporate_type
      @corporate_type = CorporateType.find(params[:id])
    end

    def corporate_type_params
      params.require(:corporate_type).permit(:name, :description)
    end
end
