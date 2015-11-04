class OrderListMilesController < ApplicationController
  before_action :set_order_list_mile, only: [:show, :edit, :update, :destroy]

  # GET /order_list_miles
  # GET /order_list_miles.json
  def index
    @order_list_miles = OrderListMile.all
  end

  # GET /order_list_miles/1
  # GET /order_list_miles/1.json
  def show
  end

  # GET /order_list_miles/new
  def new
    @order_list_mile = OrderListMile.new
  end

  # GET /order_list_miles/1/edit
  def edit
  end

  # POST /order_list_miles
  # POST /order_list_miles.json
  def create
    @order_list_mile = OrderListMile.new(order_list_mile_params)

    respond_to do |format|
      if @order_list_mile.save
        format.html { redirect_to @order_list_mile, notice: 'Order list mile was successfully created.' }
        format.json { render :show, status: :created, location: @order_list_mile }
      else
        format.html { render :new }
        format.json { render json: @order_list_mile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /order_list_miles/1
  # PATCH/PUT /order_list_miles/1.json
  def update
    respond_to do |format|
      if @order_list_mile.update(order_list_mile_params)
        format.html { redirect_to @order_list_mile, notice: 'Order list mile was successfully updated.' }
        format.json { render :show, status: :ok, location: @order_list_mile }
      else
        format.html { render :edit }
        format.json { render json: @order_list_mile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /order_list_miles/1
  # DELETE /order_list_miles/1.json
  def destroy
    @order_list_mile.destroy
    respond_to do |format|
      format.html { redirect_to order_list_miles_url, notice: 'Order list mile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order_list_mile
      @order_list_mile = OrderListMile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_list_mile_params
      params.require(:order_list_mile).permit(:name, :sort_order, :description)
    end
end
