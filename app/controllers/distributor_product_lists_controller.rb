class DistributorProductListsController < ApplicationController
  before_action :set_distributor_product_list, only: [:show, :edit, :update, :destroy]

  # GET /distributor_product_lists
  # GET /distributor_product_lists.json
  def index
      @all_product_list = DistributorProductList.all.pluck(:product_list_id)
      @product_list = ProductList.joins(:product_variant).where("product_variants.activeid = 10000").where('id NOT IN (?)', @all_product_list).order('product_lists.name')
    @distributor_product_lists = DistributorProductList.all.paginate(:page => params[:page])

      @distributor_product_list = DistributorProductList.new
  end

  # GET /distributor_product_lists/1
  # GET /distributor_product_lists/1.json
  def show
  end

  # GET /distributor_product_lists/new
  def new
    @distributor_product_list = DistributorProductList.new
  end

  # GET /distributor_product_lists/1/edit
  def edit
  end

  # POST /distributor_product_lists
  # POST /distributor_product_lists.json
  def create
    @distributor_product_list = DistributorProductList.new(distributor_product_list_params)

    respond_to do |format|
      if @distributor_product_list.save
        format.html { redirect_to @distributor_product_list, notice: 'Distributor product list was successfully created.' }
        format.json { render :show, status: :created, location: @distributor_product_list }
      else
        format.html { render :new }
        format.json { render json: @distributor_product_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /distributor_product_lists/1
  # PATCH/PUT /distributor_product_lists/1.json
  def update
    respond_to do |format|
      if @distributor_product_list.update(distributor_product_list_params)
        format.html { redirect_to @distributor_product_list, notice: 'Distributor product list was successfully updated.' }
        format.json { render :show, status: :ok, location: @distributor_product_list }
      else
        format.html { render :edit }
        format.json { render json: @distributor_product_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /distributor_product_lists/1
  # DELETE /distributor_product_lists/1.json
  def destroy
    @distributor_product_list.destroy
    respond_to do |format|
      format.html { redirect_to distributor_product_lists_url, notice: 'Distributor product list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_distributor_product_list
      @distributor_product_list = DistributorProductList.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def distributor_product_list_params
      params.require(:distributor_product_list).permit(:product_list_id, :name, :sort_order)
    end
end
