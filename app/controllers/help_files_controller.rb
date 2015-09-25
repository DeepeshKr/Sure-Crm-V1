class HelpFilesController < ApplicationController
  before_action :set_help_file, only: [:show, :edit, :update, :destroy]

  # GET /help_files
  # GET /help_files.json
  def index
    @help_files = HelpFile.all
  end

  # GET /help_files/1
  # GET /help_files/1.json
  def show
  end

  # GET /help_files/new
  def new
    @help_file = HelpFile.new
  end

  # GET /help_files/1/edit
  def edit
  end

  # POST /help_files
  # POST /help_files.json
  def create
    @help_file = HelpFile.new(help_file_params)

    respond_to do |format|
      if @help_file.save
        format.html { redirect_to @help_file, notice: 'Help file was successfully created.' }
        format.json { render :show, status: :created, location: @help_file }
      else
        format.html { render :new }
        format.json { render json: @help_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /help_files/1
  # PATCH/PUT /help_files/1.json
  def update
    respond_to do |format|
      if @help_file.update(help_file_params)
        format.html { redirect_to @help_file, notice: 'Help file was successfully updated.' }
        format.json { render :show, status: :ok, location: @help_file }
      else
        format.html { render :edit }
        format.json { render json: @help_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /help_files/1
  # DELETE /help_files/1.json
  def destroy
    @help_file.destroy
    respond_to do |format|
      format.html { redirect_to help_files_url, notice: 'Help file was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_help_file
      @help_file = HelpFile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def help_file_params
      params.require(:help_file).permit(:name, :link, :description, :code_used, :database_used, :tags, :employee_id)
    end
end
