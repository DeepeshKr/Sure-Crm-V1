class AppUserSatisfactionLevelsController < ApplicationController
  before_action { protect_controllers(7) }
  before_action :set_app_user_satisfaction_level, only: [:show, :edit, :update, :destroy]

  # GET /app_user_satisfaction_levels
  # GET /app_user_satisfaction_levels.json
  def index
    @app_user_satisfaction_levels = AppUserSatisfactionLevel.all
  end

  # GET /app_user_satisfaction_levels/1
  # GET /app_user_satisfaction_levels/1.json
  def show
  end

  # GET /app_user_satisfaction_levels/new
  def new
    @app_user_satisfaction_level = AppUserSatisfactionLevel.new
  end

  # GET /app_user_satisfaction_levels/1/edit
  def edit
  end

  # POST /app_user_satisfaction_levels
  # POST /app_user_satisfaction_levels.json
  def create
    @app_user_satisfaction_level = AppUserSatisfactionLevel.new(app_user_satisfaction_level_params)

    respond_to do |format|
      if @app_user_satisfaction_level.save
        format.html { redirect_to @app_user_satisfaction_level, notice: 'App user satisfaction level was successfully created.' }
        format.json { render :show, status: :created, location: @app_user_satisfaction_level }
      else
        format.html { render :new }
        format.json { render json: @app_user_satisfaction_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_user_satisfaction_levels/1
  # PATCH/PUT /app_user_satisfaction_levels/1.json
  def update
    respond_to do |format|
      if @app_user_satisfaction_level.update(app_user_satisfaction_level_params)
        format.html { redirect_to @app_user_satisfaction_level, notice: 'App user satisfaction level was successfully updated.' }
        format.json { render :show, status: :ok, location: @app_user_satisfaction_level }
      else
        format.html { render :edit }
        format.json { render json: @app_user_satisfaction_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_user_satisfaction_levels/1
  # DELETE /app_user_satisfaction_levels/1.json
  def destroy
    @app_user_satisfaction_level.destroy
    respond_to do |format|
      format.html { redirect_to app_user_satisfaction_levels_url, notice: 'App user satisfaction level was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_user_satisfaction_level
      @app_user_satisfaction_level = AppUserSatisfactionLevel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def app_user_satisfaction_level_params
      params.require(:app_user_satisfaction_level).permit(:name, :priority_no, :description)
    end
end
