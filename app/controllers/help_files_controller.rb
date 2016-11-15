class HelpFilesController < ApplicationController
  before_action :set_help_file, only: [:show, :edit, :update, :destroy]
  before_action :set_host
 
  # GET /help_files
  # GET /help_files.json
  def index
    
    if params[:search].present?
      @search = params[:search].downcase
      @help_files = HelpFile.where("LOWER(name) like ? or LOWER(description) like ? or LOWER(link) like ? 
      or LOWER(tags) like ?", "%#{@search}%", "%#{@search}%", "%#{@search}%", "%#{@search}%")
      .order(updated_at: :desc)
      .paginate(:page => params[:page]) #.all
      @showing_search = "Help results for #{@search} found #{@help_files.count}"
       
    elsif params.has_key? :valid
    
      @search = "Valid Help "
      @help_files = HelpFile.where("parameters is not null").order(updated_at: :DESC)
      .paginate(:page => params[:page]) #.all
      @showing_search = "Help results for #{@search} found #{@help_files.count}"
         
    else
     
      @help_files = HelpFile.all.order(updated_at: :DESC).paginate(:page => params[:page]) #.all
       @showing_search = "Help List"
    end
    
    
  end
  
  def import
    # HelpFile.import(params[:file])
     redirect_to help_files_url, notice: "No Help File entries imported."
  end

  # GET /help_files/1
  # GET /help_files/1.json
  def show
    @search = @help_file.tags.downcase
    
    @features_searched = AppFeatureRequest.joins(:app_feature_comment).where("LOWER(problem_this_solves) like ? 
    or LOWER(mandatory_requirements) like ? or LOWER(technical_notes) like ? or LOWER(extra_notes) like ? 
    or LOWER(name) like ? or LOWER(app_feature_comments.details) like ?", 
    "%#{@search}%", "%#{@search}%", "%#{@search}%", "%#{@search}%", 
    "%#{@search}%", "%#{@search}%")
    .paginate(:page => params[:page]) #.all
    
  end

  # GET /help_files/new
  def new
    employee = Employee.where(employeecode: current_user.employee_code).first
    @help_file = HelpFile.new(employee_id: employee.id)
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
    @employee = Employee.where(employeecode: current_user.employee_code).first
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
 # <%= collection_selct( :invoice, :sales_person_id, SalesPerson.all, :id, :name, {}, {:multipel => false} ) %>
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
    def set_host
      # for returning to the same page
     @host = request.host
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def help_file_params
      params.require(:help_file).permit(:name, :link, :description, :code_used, 
      :database_used, :tags, :employee_id, :domain,  :controller, :action, 
      :screen_shot, :parameters)
    end
end
