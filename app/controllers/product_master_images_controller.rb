class ProductMasterImagesController < ApplicationController
  before_action :set_product_master_image, only: [:show, :edit, :update, :destroy]

  # GET /product_master_images
  # GET /product_master_images.json
  def index
    @product_master_images = ProductMasterImage.all
  end

  # GET /product_master_images/1
  # GET /product_master_images/1.json
  def show
  end

  # GET /product_master_images/new
  def new
    @product_master_image = ProductMasterImage.new
  end

  # GET /product_master_images/1/edit
  def edit
  end

  # POST /product_master_images
  # POST /product_master_images.json
  def create
    @product_master_image = ProductMasterImage.new(product_master_image_params)

    respond_to do |format|
      if @product_master_image.save
        format.html { redirect_to @product_master_image, notice: 'Product master image was successfully created.' }
        format.json { render :show, status: :created, location: @product_master_image }
      else
        format.html { render :new }
        format.json { render json: @product_master_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /product_master_images/1
  # PATCH/PUT /product_master_images/1.json
  def update
    respond_to do |format|
      if @product_master_image.update(product_master_image_params)
        format.html { redirect_to @product_master_image, notice: 'Product master image was successfully updated.' }
        format.json { render :show, status: :ok, location: @product_master_image }
      else
        format.html { render :edit }
        format.json { render json: @product_master_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_master_images/1
  # DELETE /product_master_images/1.json
  def destroy
    @product_master_image.destroy
    respond_to do |format|
      format.html { redirect_to product_master_images_url, notice: 'Product master image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_master_image
      @product_master_image = ProductMasterImage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_master_image_params
      params.require(:product_master_image).permit(:name, :description, :sort_order, :prod, :barcode, :product_variant_id, :product_list_id, :product_master_id)
    end
end
