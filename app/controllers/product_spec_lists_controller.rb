class ProductSpecListsController < ApplicationController
   before_action { protect_controllers(8) } 
  before_action :set_product_spec_list, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @product_spec_lists = ProductSpecList.all
    respond_with(@product_spec_lists)
  end

  def show
    respond_with(@product_spec_list)
  end

  def new
    @product_spec_list = ProductSpecList.new
    respond_with(@product_spec_list)
  end

  def edit
  end

  def create
    @product_spec_list = ProductSpecList.new(product_spec_list_params)
    @product_spec_list.save
    spec_1 = product_spec_list_params[:spec_1]
    spec_2 = product_spec_list_params[:spec_2]
    spec_3 = product_spec_list_params[:spec_3]
    spec_4 = product_spec_list_params[:spec_4]
    spec_5 = product_spec_list_params[:spec_5]

    @product_spec_list.update(name: spec_1 << " " << spec_2 << " " << spec_3 << " " << spec_4 << " " <<spec_5)
    respond_with(@product_spec_list)
  end

  def update
    @product_spec_list.update(product_spec_list_params)
    spec_1 = product_spec_list_params[:spec_1]
    spec_2 = product_spec_list_params[:spec_2]
    spec_3 = product_spec_list_params[:spec_3]
    spec_4 = product_spec_list_params[:spec_4]
    spec_5 = product_spec_list_params[:spec_5]

    @product_spec_list.update(name: spec_1 << " " << spec_2 << " " << spec_3 << " " << spec_4 << " " <<spec_5)
 
    respond_with(@product_spec_list)
  end

  def destroy
    @product_spec_list.destroy
    respond_with(@product_spec_list)
  end

  private
    def set_product_spec_list
      @product_spec_list = ProductSpecList.find(params[:id])
    end

    def product_spec_list_params
      params.require(:product_spec_list).permit(:name, :spec_1, :spec_2, :spec_3, :spec_4, :spec_5, :description)
    end
end
