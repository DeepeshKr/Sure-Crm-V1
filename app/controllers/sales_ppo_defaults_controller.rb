class SalesPpoDefaultsController < ApplicationController
  before_action :set_sales_ppo_default, only: [:show, :edit, :update, :destroy]

  # GET /sales_ppo_defaults
  # GET /sales_ppo_defaults.json
  def index
    @sales_ppo_defaults = SalesPpoDefault.all
  end

  # GET /sales_ppo_defaults/1
  # GET /sales_ppo_defaults/1.json
  def show
  end

  # GET /sales_ppo_defaults/new
  def new
    @sales_ppo_default = SalesPpoDefault.new
  end

  # GET /sales_ppo_defaults/1/edit
  def edit
  end

  # POST /sales_ppo_defaults
  # POST /sales_ppo_defaults.json
  def create
    @sales_ppo_default = SalesPpoDefault.new(sales_ppo_default_params)

    respond_to do |format|
      if @sales_ppo_default.save
        format.html { redirect_to @sales_ppo_default, notice: 'Sales ppo default was successfully created, please refresh the PPO pages to see the values change.' }
        format.json { render :show, status: :created, location: @sales_ppo_default }
      else
        format.html { render :new }
        format.json { render json: @sales_ppo_default.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sales_ppo_defaults/1
  # PATCH/PUT /sales_ppo_defaults/1.json
  def update
    respond_to do |format|
      if @sales_ppo_default.update(sales_ppo_default_params)
        format.html { redirect_to @sales_ppo_default, notice: 'Sales ppo default was successfully updated.' }
        format.json { render :show, status: :ok, location: @sales_ppo_default }
      else
        format.html { render :edit }
        format.json { render json: @sales_ppo_default.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales_ppo_defaults/1
  # DELETE /sales_ppo_defaults/1.json
  def destroy
    @sales_ppo_default.destroy
    respond_to do |format|
      format.html { redirect_to sales_ppo_defaults_url, notice: 'Sales ppo default was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sales_ppo_default
      @sales_ppo_default = SalesPpoDefault.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sales_ppo_default_params
      params.require(:sales_ppo_default).permit(:name, :value, :description)
    end
end
