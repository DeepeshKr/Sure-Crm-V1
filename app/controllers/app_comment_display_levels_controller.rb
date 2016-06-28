class AppCommentDisplayLevelsController < ApplicationController
  before_action { protect_controllers(7) }
  before_action :set_app_comment_display_level, only: [:show, :edit, :update, :destroy]

  # GET /app_comment_display_levels
  # GET /app_comment_display_levels.json
  def index
    @app_comment_display_levels = AppCommentDisplayLevel.all
  end

  # GET /app_comment_display_levels/1
  # GET /app_comment_display_levels/1.json
  def show
  end

  # GET /app_comment_display_levels/new
  def new
    @app_comment_display_level = AppCommentDisplayLevel.new
  end

  # GET /app_comment_display_levels/1/edit
  def edit
  end

  # POST /app_comment_display_levels
  # POST /app_comment_display_levels.json
  def create
    @app_comment_display_level = AppCommentDisplayLevel.new(app_comment_display_level_params)

    respond_to do |format|
      if @app_comment_display_level.save
        format.html { redirect_to @app_comment_display_level, notice: 'App comment display level was successfully created.' }
        format.json { render :show, status: :created, location: @app_comment_display_level }
      else
        format.html { render :new }
        format.json { render json: @app_comment_display_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_comment_display_levels/1
  # PATCH/PUT /app_comment_display_levels/1.json
  def update
    respond_to do |format|
      if @app_comment_display_level.update(app_comment_display_level_params)
        format.html { redirect_to @app_comment_display_level, notice: 'App comment display level was successfully updated.' }
        format.json { render :show, status: :ok, location: @app_comment_display_level }
      else
        format.html { render :edit }
        format.json { render json: @app_comment_display_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_comment_display_levels/1
  # DELETE /app_comment_display_levels/1.json
  def destroy
    @app_comment_display_level.destroy
    respond_to do |format|
      format.html { redirect_to app_comment_display_levels_url, notice: 'App comment display level was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_comment_display_level
      @app_comment_display_level = AppCommentDisplayLevel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def app_comment_display_level_params
      params.require(:app_comment_display_level).permit(:name, :priority_no, :description)
    end
end
