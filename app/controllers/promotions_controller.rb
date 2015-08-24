class PromotionsController < ApplicationController
  before_action :set_promotion, only: [:show, :edit, :update, :destroy]

  # GET /promotions
  # GET /promotions.json
  def index
     @for_date = (330.minutes).from_now.to_date.strftime("%Y-%m-%d")

     todaydate = (330.minutes).from_now.to_date
    if params.has_key?(:for_date)
     @for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")
     todaydate
    end
    #:start_date, :end_date
    @promotions = Promotion.all
    @live_promotions = Promotion.where('TRUNC(start_date) <= ? and TRUNC(end_date) >= ?', todaydate, todaydate)
    @live_not_active_promotions = Promotion.all
    @upcoming_promotions = Promotion.all
  end

  # GET /promotions/1
  # GET /promotions/1.json
  def show
  end

  # GET /promotions/new
  def new
    drop_downs
    @promotion = Promotion.new
  end

  # GET /promotions/1/edit
  def edit
    drop_downs
  end 

  # POST /promotions
  # POST /promotions.json
  def create
    @promotion = Promotion.new(promotion_params)

    respond_to do |format|
      if @promotion.save
        format.html { redirect_to @promotion, notice: 'Promotion was successfully created.' }
        format.json { render :show, status: :created, location: @promotion }
      else
        format.html { render :new }
        format.json { render json: @promotion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /promotions/1
  # PATCH/PUT /promotions/1.json
  def update
    respond_to do |format|
      if @promotion.update(promotion_params)
        format.html { redirect_to @promotion, notice: 'Promotion was successfully updated.' }
        format.json { render :show, status: :ok, location: @promotion }
      else
        format.html { render :edit }
        format.json { render json: @promotion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /promotions/1
  # DELETE /promotions/1.json
  def destroy
    @promotion.destroy
    respond_to do |format|
      format.html { redirect_to promotions_url, notice: 'Promotion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def drop_downs
     @product_lists = ProductList.joins(:product_variant)
     .where("product_variants.product_sell_type_id = ?", 10060)
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_promotion
      @promotion = Promotion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def promotion_params
      params.require(:promotion).permit(:name, :description, :start_hr, :start_min, :end_hr, :end_min, :start_date, :end_date, :media_id, :min_sale_value, :discount_percent, :discount_value, :free_product_list_id, :active, :unique_code, :promo_cost)
    end
end
