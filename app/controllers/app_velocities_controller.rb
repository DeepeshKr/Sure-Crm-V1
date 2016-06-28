class AppVelocitiesController < ApplicationController
  before_action { protect_controllers(7) }
  before_action :set_app_velocity, only: [:show, :edit, :update, :destroy]

  # GET /app_velocities
  # GET /app_velocities.json
  def index
    @app_velocities = AppVelocity.all
  end

  # GET /app_velocities/1
  # GET /app_velocities/1.json
  def show
  end

  # GET /app_velocities/new
  def new
    @app_velocity = AppVelocity.new
  end

  # GET /app_velocities/1/edit
  def edit
  end

  # POST /app_velocities
  # POST /app_velocities.json
  def create
    @app_velocity = AppVelocity.new(app_velocity_params)

    respond_to do |format|
      if @app_velocity.save
        format.html { redirect_to @app_velocity, notice: 'App velocity was successfully created.' }
        format.json { render :show, status: :created, location: @app_velocity }
      else
        format.html { render :new }
        format.json { render json: @app_velocity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_velocities/1
  # PATCH/PUT /app_velocities/1.json
  def update
    respond_to do |format|
      if @app_velocity.update(app_velocity_params)
        format.html { redirect_to @app_velocity, notice: 'App velocity was successfully updated.' }
        format.json { render :show, status: :ok, location: @app_velocity }
      else
        format.html { render :edit }
        format.json { render json: @app_velocity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_velocities/1
  # DELETE /app_velocities/1.json
  def destroy
    @app_velocity.destroy
    respond_to do |format|
      format.html { redirect_to app_velocities_url, notice: 'App velocity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_velocity
      @app_velocity = AppVelocity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def app_velocity_params
      params.require(:app_velocity).permit(:name, :priority_no, :description)
    end
end
