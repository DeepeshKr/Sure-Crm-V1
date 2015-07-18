class ProductTestPposController < ApplicationController
  before_action { protect_controllers_specific(6) } 
  before_action :set_product_test_ppo, only: [:show, :edit, :update, :destroy]

  # GET /product_test_ppos
  # GET /product_test_ppos.json
  def index
    @product_test_ppos = ProductTestPpo.all.order("aired_date DESC")
    .paginate(:page => params[:page])
    @product_test_ppo = ProductTestPpo.new
    #<%= link_to 'New Product test ppo', new_product_test_ppo_path %>
  end

  # GET /product_test_ppos/1
  # GET /product_test_ppos/1.json
  def show
  end

  # GET /product_test_ppos/new
  def new
    @product_test_ppo = ProductTestPpo.new
  end

  # GET /product_test_ppos/1/edit
  def edit
  end

  # POST /product_test_ppos
  # POST /product_test_ppos.json
  def create
    @product_test_ppo = ProductTestPpo.new(product_test_ppo_params)

    respond_to do |format|
      if @product_test_ppo.save
        format.html { redirect_to @product_test_ppo, notice: 'Product test ppo was successfully created.' }
        format.json { render :show, status: :created, location: @product_test_ppo }
      else
        format.html { render :new }
        format.json { render json: @product_test_ppo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /product_test_ppos/1
  # PATCH/PUT /product_test_ppos/1.json
  def update
    respond_to do |format|
      if @product_test_ppo.update(product_test_ppo_params)
        format.html { redirect_to @product_test_ppo, notice: 'Product test ppo was successfully updated.' }
        format.json { render :show, status: :ok, location: @product_test_ppo }
      else
        format.html { render :edit }
        format.json { render json: @product_test_ppo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_test_ppos/1
  # DELETE /product_test_ppos/1.json
  def destroy
    @product_test_ppo.destroy
    respond_to do |format|
      format.html { redirect_to product_test_ppos_url, notice: 'Product test ppo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_test_ppo
      @product_test_ppo = ProductTestPpo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_test_ppo_params
      params.require(:product_test_ppo).permit(:name, :prod_code, :barcode, :basic_price, :shipping, :channel, :aired_date, :slot, :orders, :ppo, :ad_cost, :description)
    end
end
