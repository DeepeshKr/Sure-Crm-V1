class CampaignPlaylistToProductsController < ApplicationController
  before_action :set_campaign_playlist_to_product, only: [:show, :edit, :update, :destroy]

  # GET /campaign_playlist_to_products
  # GET /campaign_playlist_to_products.json
  def index
    @campaign_playlist_to_products = CampaignPlaylistToProduct.all
  end

  # GET /campaign_playlist_to_products/1
  # GET /campaign_playlist_to_products/1.json
  def show
  end

  # GET /campaign_playlist_to_products/new
  def new
    @product_variants = ProductVariant.where('activeid = 10000').order("name")
    @campaign_playlist_to_product = CampaignPlaylistToProduct.new
    #@product_variants = ProductVariant.where('activeid = 10000').order("name")
  end

  # GET /campaign_playlist_to_products/1/edit
  def edit
    @product_variants = ProductVariant.where('activeid = 10000').order("name")
   
    #@product_variants = ProductVariant.where('activeid = 10000').order("name")
  end

  # POST /campaign_playlist_to_products
  # POST /campaign_playlist_to_products.json
  def create
    @campaign_playlist_to_product = CampaignPlaylistToProduct.new(campaign_playlist_to_product_params)

    respond_to do |format|
      if @campaign_playlist_to_product.save
        format.html { redirect_to controller: "campaign_playlists", action: "search", id: @campaign_playlist_to_product.campaign_playlist_id, notice: 'Campaign playlist to product was successfully created.' }
        
        # format.html { redirect_to @campaign_playlist_to_product, notice: 'Campaign playlist to product was successfully created.' }
         format.json { render :show, status: :created, location: @campaign_playlist_to_product }
      else
        format.html { render :new }
        format.json { render json: @campaign_playlist_to_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /campaign_playlist_to_products/1
  # PATCH/PUT /campaign_playlist_to_products/1.json
  def update
    respond_to do |format|
      if @campaign_playlist_to_product.update(campaign_playlist_to_product_params)
        format.html { redirect_to controller: "campaign_playlists", action: "search", id: @campaign_playlist_to_product.campaign_playlist_id, notice: 'Campaign playlist to product was successfully update.' }
     
     
        # format.html { redirect_to @campaign_playlist_to_product, notice: 'Campaign playlist to product was successfully updated.' }
        format.json { render :show, status: :ok, location: @campaign_playlist_to_product }
      else
        format.html { render :edit }
        format.json { render json: @campaign_playlist_to_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /campaign_playlist_to_products/1
  # DELETE /campaign_playlist_to_products/1.json
  def destroy
    @campaign_playlist_to_product.destroy
    respond_to do |format|
      format.html { redirect_to controller: "campaign_playlists", action: "search", id: @campaign_playlist_to_product.campaign_playlist_id, notice: 'Campaign playlist to product was successfully destroyed.' }
   
      # format.html { redirect_to campaign_playlist_to_products_url, notice: 'Campaign playlist to product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_campaign_playlist_to_product
      @campaign_playlist_to_product = CampaignPlaylistToProduct.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def campaign_playlist_to_product_params
      params.require(:campaign_playlist_to_product).permit(:name, :campaign_playlist_id, :product_variant_id)
    end
end
