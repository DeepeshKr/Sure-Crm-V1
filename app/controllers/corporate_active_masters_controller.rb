class CorporateActiveMastersController < ApplicationController
  before_action :set_corporate_active_master, only: [:show, :edit, :update, :destroy]

  # GET /corporate_active_masters
  # GET /corporate_active_masters.json
  def index
    @corporate_active_masters = CorporateActiveMaster.all
  end

  # GET /corporate_active_masters/1
  # GET /corporate_active_masters/1.json
  def show
  end

  # GET /corporate_active_masters/new
  def new
    @corporate_active_master = CorporateActiveMaster.new
  end

  # GET /corporate_active_masters/1/edit
  def edit
  end

  # POST /corporate_active_masters
  # POST /corporate_active_masters.json
  def create
    @corporate_active_master = CorporateActiveMaster.new(corporate_active_master_params)

    respond_to do |format|
      if @corporate_active_master.save
        format.html { redirect_to @corporate_active_master, notice: 'Corporate active master was successfully created.' }
        format.json { render :show, status: :created, location: @corporate_active_master }
      else
        format.html { render :new }
        format.json { render json: @corporate_active_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /corporate_active_masters/1
  # PATCH/PUT /corporate_active_masters/1.json
  def update
    respond_to do |format|
      if @corporate_active_master.update(corporate_active_master_params)
        format.html { redirect_to @corporate_active_master, notice: 'Corporate active master was successfully updated.' }
        format.json { render :show, status: :ok, location: @corporate_active_master }
      else
        format.html { render :edit }
        format.json { render json: @corporate_active_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /corporate_active_masters/1
  # DELETE /corporate_active_masters/1.json
  def destroy
    @corporate_active_master.destroy
    respond_to do |format|
      format.html { redirect_to corporate_active_masters_url, notice: 'Corporate active master was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_corporate_active_master
      @corporate_active_master = CorporateActiveMaster.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def corporate_active_master_params
      params.require(:corporate_active_master).permit(:name, :sort_order, :description)
    end
end
