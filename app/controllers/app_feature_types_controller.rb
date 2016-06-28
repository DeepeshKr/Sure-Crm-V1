class AppFeatureTypesController < ApplicationController
  before_action { protect_controllers(7) }
  before_action :set_app_feature_type, only: [:show, :edit, :update, :destroy]

  # GET /app_feature_types
  # GET /app_feature_types.json
  def index
    @app_feature_types = AppFeatureType.all
  end

  # GET /app_feature_types/1
  # GET /app_feature_types/1.json
  def show
  end

  # GET /app_feature_types/new
  def new
    @app_feature_type = AppFeatureType.new
  end

  # GET /app_feature_types/1/edit
  def edit
  end

  # POST /app_feature_types
  # POST /app_feature_types.json
  def create
    @app_feature_type = AppFeatureType.new(app_feature_type_params)

    respond_to do |format|
      if @app_feature_type.save
        format.html { redirect_to @app_feature_type, notice: 'App feature type was successfully created.' }
        format.json { render :show, status: :created, location: @app_feature_type }
      else
        format.html { render :new }
        format.json { render json: @app_feature_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_feature_types/1
  # PATCH/PUT /app_feature_types/1.json
  def update
    respond_to do |format|
      if @app_feature_type.update(app_feature_type_params)
        format.html { redirect_to @app_feature_type, notice: 'App feature type was successfully updated.' }
        format.json { render :show, status: :ok, location: @app_feature_type }
      else
        format.html { render :edit }
        format.json { render json: @app_feature_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_feature_types/1
  # DELETE /app_feature_types/1.json
  def destroy
    @app_feature_type.destroy
    respond_to do |format|
      format.html { redirect_to app_feature_types_url, notice: 'App feature type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_feature_type
      @app_feature_type = AppFeatureType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def app_feature_type_params
      params.require(:app_feature_type).permit(:name, :priority_no, :description)
    end
end
