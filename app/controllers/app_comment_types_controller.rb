class AppCommentTypesController < ApplicationController
  before_action { protect_controllers(7) }
  before_action :set_app_comment_type, only: [:show, :edit, :update, :destroy]

  # GET /app_comment_types
  # GET /app_comment_types.json
  def index
    @app_comment_types = AppCommentType.all
  end

  # GET /app_comment_types/1
  # GET /app_comment_types/1.json
  def show
  end

  # GET /app_comment_types/new
  def new
    @app_comment_type = AppCommentType.new
  end

  # GET /app_comment_types/1/edit
  def edit
  end

  # POST /app_comment_types
  # POST /app_comment_types.json
  def create
    @app_comment_type = AppCommentType.new(app_comment_type_params)

    respond_to do |format|
      if @app_comment_type.save
        format.html { redirect_to @app_comment_type, notice: 'App comment type was successfully created.' }
        format.json { render :show, status: :created, location: @app_comment_type }
      else
        format.html { render :new }
        format.json { render json: @app_comment_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_comment_types/1
  # PATCH/PUT /app_comment_types/1.json
  def update
    respond_to do |format|
      if @app_comment_type.update(app_comment_type_params)
        format.html { redirect_to @app_comment_type, notice: 'App comment type was successfully updated.' }
        format.json { render :show, status: :ok, location: @app_comment_type }
      else
        format.html { render :edit }
        format.json { render json: @app_comment_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_comment_types/1
  # DELETE /app_comment_types/1.json
  def destroy
    @app_comment_type.destroy
    respond_to do |format|
      format.html { redirect_to app_comment_types_url, notice: 'App comment type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_comment_type
      @app_comment_type = AppCommentType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def app_comment_type_params
      params.require(:app_comment_type).permit(:name, :priority_no, :description)
    end
end
