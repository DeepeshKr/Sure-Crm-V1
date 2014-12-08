class ProductTrainingHeadingsController < ApplicationController
  before_action :set_product_training_heading, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @product_training_headings = ProductTrainingHeading.all
    respond_with(@product_training_headings)
  end

  def show
    respond_with(@product_training_heading)
  end

  def new
    @product_training_heading = ProductTrainingHeading.new
    respond_with(@product_training_heading)
  end

  def edit
  end

  def create
    @product_training_heading = ProductTrainingHeading.new(product_training_heading_params)
    @product_training_heading.save
    respond_with(@product_training_heading)
  end

  def update
    @product_training_heading.update(product_training_heading_params)
    respond_with(@product_training_heading)
  end

  def destroy
    @product_training_heading.destroy
    respond_with(@product_training_heading)
  end

  private
    def set_product_training_heading
      @product_training_heading = ProductTrainingHeading.find(params[:id])
    end

    def product_training_heading_params
      params.require(:product_training_heading).permit(:name, :sortorder)
    end
end
