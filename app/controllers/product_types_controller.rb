class ProductTypesController < ApplicationController
  before_action :set_product_type, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @product_types = ProductType.all
    respond_with(@product_types)
  end

  def show
    respond_with(@product_type)
  end

  def new
    @product_type = ProductType.new
    respond_with(@product_type)
  end

  def edit
  end

  def create
    @product_type = ProductType.new(product_type_params)
    @product_type.save
    respond_with(@product_type)
  end

  def update
    @product_type.update(product_type_params)
    respond_with(@product_type)
  end

  def destroy
    @product_type.destroy
    respond_with(@product_type)
  end

  private
    def set_product_type
      @product_type = ProductType.find(params[:id])
    end

    def product_type_params
      params.require(:product_type).permit(:name)
    end
end
