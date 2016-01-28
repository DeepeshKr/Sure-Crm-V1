class RegistrationStatusesController < ApplicationController
  before_action :set_registration_status, only: [:show, :edit, :update, :destroy]

  # GET /registration_statuses
  # GET /registration_statuses.json
  def index
    @registration_statuses = RegistrationStatus.all
  end

  # GET /registration_statuses/1
  # GET /registration_statuses/1.json
  def show
  end

  # GET /registration_statuses/new
  def new
    @registration_status = RegistrationStatus.new
  end

  # GET /registration_statuses/1/edit
  def edit
  end

  # POST /registration_statuses
  # POST /registration_statuses.json
  def create
    @registration_status = RegistrationStatus.new(registration_status_params)

    respond_to do |format|
      if @registration_status.save
        format.html { redirect_to @registration_status, notice: 'Registration status was successfully created.' }
        format.json { render :show, status: :created, location: @registration_status }
      else
        format.html { render :new }
        format.json { render json: @registration_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /registration_statuses/1
  # PATCH/PUT /registration_statuses/1.json
  def update
    respond_to do |format|
      if @registration_status.update(registration_status_params)
        format.html { redirect_to @registration_status, notice: 'Registration status was successfully updated.' }
        format.json { render :show, status: :ok, location: @registration_status }
      else
        format.html { render :edit }
        format.json { render json: @registration_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /registration_statuses/1
  # DELETE /registration_statuses/1.json
  def destroy
    @registration_status.destroy
    respond_to do |format|
      format.html { redirect_to registration_statuses_url, notice: 'Registration status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_registration_status
      @registration_status = RegistrationStatus.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def registration_status_params
      params.require(:registration_status).permit(:name, :description, :sort_order)
    end
end
