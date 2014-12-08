class ProductActiveCodesController < ApplicationController
  before_action :set_product_active_code, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @product_active_codes = ProductActiveCode.all
    respond_with(@product_active_codes)
  end

  def show
    respond_with(@product_active_code)
  end

  def new
    @product_active_code = ProductActiveCode.new
    respond_with(@product_active_code)
  end

  def edit
  end

  def create
    @product_active_code = ProductActiveCode.new(product_active_code_params)
    @product_active_code.save
    respond_with(@product_active_code)
  end

  def update
    @product_active_code.update(product_active_code_params)
    respond_with(@product_active_code)
  end

  def destroy
    @product_active_code.destroy
    respond_with(@product_active_code)
  end

  private
    def set_product_active_code
      @product_active_code = ProductActiveCode.find(params[:id])
    end

    def product_active_code_params
      params.require(:product_active_code).permit(:name, :sortorder)
    end
end
