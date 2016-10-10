class IndiaPincodeListsController < ApplicationController
 #, only: [:import, :edit, :update, :destroy]
  before_action :set_india_pincode_list, only: [:show, :edit, :update, :destroy]

  autocomplete :india_pincode_list, :pincode
  autocomplete :india_pincode_list, :taluk, :full => true
  autocomplete :india_pincode_list, :districtname, :full => true
  autocomplete :india_pincode_list, :regionname, :full => true
  # GET /india_pincode_lists
  # GET /india_pincode_lists.json
  # officename, :pincode,
  #   :deliverystatus, :divisionname, :regionname, :circlename, :taluk,
  #   :districtname, :statename
  def index
    #    <%= @search %> <%= @found %>
    if params[:pincode].present?
      @searchvalue = params[:pincode]
      @india_pincode_lists = IndiaPincodeList.where(pincode:  @searchvalue).paginate(:page => params[:page])
      @search = "Seached for #{@searchvalue}"
      @found = "Found of over #{@india_pincode_lists.count()} Cities"
    elsif params[:location].present?
      @searchvalue = params[:location]
      @searchvalue = @searchvalue.upcase
      @india_pincode_lists = IndiaPincodeList.where("UPPER(taluk) like ? OR UPPER(districtname) like ? or UPPER(regionname) like ? or UPPER(pincode) like ? or UPPER(divisionname) like ? or UPPER(circlename) like ? or UPPER(statename) like ?", "%#{@searchvalue}%", "%#{@searchvalue}%", "%#{@searchvalue}%", "%#{@searchvalue}%", "%#{@searchvalue}%", "%#{@searchvalue}%", "%#{@searchvalue}%").paginate(:page => params[:page])
      @search = "Seached for #{@searchvalue}"
      @found = "Found of over #{@india_pincode_lists.count()} Cities"
    elsif params.has_key?(:statename)
      @statename = params[:statename]
      @searchvalue = params[:statename].upcase
      @india_pincode_lists = IndiaPincodeList.where("UPPER(statename) = ?", "#{@searchvalue}").paginate(:page => params[:page])
      @search = "Seached for #{@searchvalue}"
      @found = "Found of over #{@india_pincode_lists.count()} Cities"
     elsif params.has_key?(:na_taluk)
       @statename = "NA"
       @searchvalue = "NA"
       @india_pincode_lists = IndiaPincodeList.where("UPPER(taluk) = ?", "#{@searchvalue}").paginate(:page => params[:page])
       @search = "Seached for #{@searchvalue}"
       @found = "Found of over #{@india_pincode_lists.count()} Cities"
    else
      nos = IndiaPincodeList.all.count()
      @search = ""
      @found = "Total Listings of over #{nos} Cities"
      @india_pincode_lists = IndiaPincodeList.all.paginate(:page => params[:page])
    end
  end

  def show_pincode
    if params.has_key?(:term)
      @searchvalue = params[:term].upcase
      @india_pincode_lists = IndiaPincodeList.where("pincode like ? OR districtname like ?", "#{@searchvalue}%", "#{@searchvalue}%").limit(200)
      #respond_to do |format|
   render json: @india_pincode_lists, methods: [:locality, :details, :location]
     # end
    end
  end
  
  def check_for_updates
    if params.has_key?(:statename)
       @statename = params[:statename]
       @unorderlist ||= []
       @update_state_from_india_post = "Update records from #{@statename} with new state for each pincode (Sample Shown Above)"
       
       json = IndiaPincodeList.check_for_changed_state @statename.upcase, nil
       #json = JSON.parse(jsonArray)
       @total_records = json["count"]
       
       redirect_to india_pincode_lists_check_for_updates_path, notice: "No records found for your search criteria!" and return  if json.blank?
       
       json["records"].each do |o|
         # do something
         @unorderlist << {:officename => o["officename"],
           :pincode => o["pincode"],
           :deliverystatus => o["Deliverystatus"],
           :divisionname => o["divisionname"],
           :circlename => o["circlename"],
           :taluk => o["Taluk"],
           :districtname => o["Districtname"],
           :regionname => o["regionname"],
           :statename => o["statename"]}
       end
     elsif params.has_key?(:pincode)
          @pincode = params[:pincode]
          @unorderlist ||= []
          @update_state_from_india_post = "You cannot update this right now"
       
          json = IndiaPincodeList.check_for_changed_state nil, @pincode
          #json = JSON.parse(jsonArray)
          @total_records = json["count"]
          
       redirect_to india_pincode_lists_check_for_updates_path, notice: "No records found for your search criteria!" and return  if json.blank?
       
       json["records"].each do |o|
         # do something
         @unorderlist << {:officename => o["officename"],
           :pincode => o["pincode"],
           :deliverystatus => o["Deliverystatus"],
           :divisionname => o["divisionname"],
           :circlename => o["circlename"],
           :taluk => o["Taluk"],
           :districtname => o["Districtname"],
           :regionname => o["regionname"],
           :statename => o["statename"]}
       end
       
    end
    
    
    
   
    
  end
  
  def update_pincode_list
    if params.has_key?(:statename)
       @statename = params[:statename]
      india_pincode =  IndiaPincodeList.new 
     records = india_pincode.update_local_db_with_changed_state @statename
         
       redirect_to india_pincode_lists_check_for_updates_path, notice: "Updated the state list #{records} from the latest in India post!" and return 
     
     else
        redirect_to india_pincode_lists_check_for_updates_path, notice: 'Nothing to update!' and return 
    end
    
  end
 

  def import
    #begin
      IndiaPincodeList.import(params[:file])
      redirect_to root_url, notice: "Products imported."
    #rescue
     # redirect_to root_url, notice: "Invalid CSV file format."
    #end
  end

  # GET /india_pincode_lists/1
  # GET /india_pincode_lists/1.json
  def show
  end

  # GET /india_pincode_lists/new
  def new
    redirect_to india_pincode_list_path, notice: 'You are not authorised to edit this!' and return if current_user.employee_role.sortorder > 8

    @india_pincode_list = IndiaPincodeList.new
  end

  # GET /india_pincode_lists/1/edit
  def edit
     redirect_to india_pincode_list_path, notice: 'You are not authorised to edit this!' and return if current_user.employee_role.sortorder > 8


  end

  # POST /india_pincode_lists
  # POST /india_pincode_lists.json
  def create
    redirect_to india_pincode_list_path, notice: 'You are not authorised to edit this!' and return if current_user.employee_role.sortorder > 8

    @india_pincode_list = IndiaPincodeList.new(india_pincode_list_params)

    respond_to do |format|
      if @india_pincode_list.save
        format.html { redirect_to @india_pincode_list, notice: 'India pincode list was successfully created.' }
        format.json { render :show, status: :created, location: @india_pincode_list }
      else
        format.html { render :new }
        format.json { render json: @india_pincode_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /india_pincode_lists/1
  # PATCH/PUT /india_pincode_lists/1.json
  def update
    edirect_to india_pincode_list_path, notice: 'You are not authorised to edit this!' and return if current_user.employee_role.sortorder > 8

    respond_to do |format|
      if @india_pincode_list.update(india_pincode_list_params)
        format.html { redirect_to @india_pincode_list, notice: 'India pincode list was successfully updated.' }
        format.json { render :show, status: :ok, location: @india_pincode_list }
      else
        format.html { render :edit }
        format.json { render json: @india_pincode_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /india_pincode_lists/1
  # DELETE /india_pincode_lists/1.json
  def destroy
      before_action {protect_controllers(8)}
    @india_pincode_list.destroy
    respond_to do |format|
      format.html { redirect_to india_pincode_lists_url, notice: 'India pincode list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def url_response encoded_url
      url = URI.parse(encoded_url)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(url)
      response = http.request(request)
    end
    
    def set_india_pincode_list
      @india_pincode_list = IndiaPincodeList.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def india_pincode_list_params
      params.require(:india_pincode_list).permit(:officename, :pincode,
        :deliverystatus, :divisionname, :regionname, :circlename, :taluk,
        :districtname, :statename)
    end
end
