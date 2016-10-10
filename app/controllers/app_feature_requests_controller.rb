class AppFeatureRequestsController < ApplicationController
  before_action { protect_controllers(11) }
  before_action :set_app_feature_request, only: [:show, :edit, :update, :destroy]
  before_action :employee_id, :current_time
  before_action :show_edit, only: [:show, :edit, :update]
  # GET /app_feature_requests
  # GET /app_feature_requests.json
  def index
    
    working = [10006, 10009]
    already_covered = [10000,10003,10004, 10008, 10010, 10012]
    delayed = [10001, 10002, 10007, 10011]
    others = working + already_covered + delayed
    @app_new_features = AppFeatureRequest.where(app_feature_type_id: 10000, current_status_id: 10000).order("id desc")
    @app_new_errors = AppFeatureRequest.where(app_feature_type_id: 10001, current_status_id: 10000).order("id desc")
    
    @app_log_features = AppFeatureRequest.where(app_feature_type_id: 10000, current_status_id: 10003).order("id desc")
    @app_log_errors = AppFeatureRequest.where(app_feature_type_id: 10001, current_status_id: 10003).order("id desc")
 
    @app_queued_features = AppFeatureRequest.where(app_feature_type_id: 10000, current_status_id: 10004).order("id desc")
    @app_queued_errors = AppFeatureRequest.where(app_feature_type_id: 10001, current_status_id: 10004).order("id desc")
    
    @app_working_features = AppFeatureRequest.where(app_feature_type_id: 10000, current_status_id: working).order("id desc")
    @app_working_errors = AppFeatureRequest.where(app_feature_type_id: 10001, current_status_id: working).order("id desc")

    @app_testing_features = AppFeatureRequest.where(app_feature_type_id: 10000, current_status_id: 10008).order("id desc")
    @app_testing_errors = AppFeatureRequest.where(app_feature_type_id: 10001, current_status_id: 10008).order("id desc")

    @app_beta_features = AppFeatureRequest.where(app_feature_type_id: 10000, current_status_id: 10010).order("id desc")
    @app_beta_errors = AppFeatureRequest.where(app_feature_type_id: 10001, current_status_id: 10010).order("id desc")
    
    @app_delayed_features = AppFeatureRequest.where(app_feature_type_id: 10000).where(current_status_id: delayed).order("id desc")
    @app_delayed_errors = AppFeatureRequest.where(app_feature_type_id: 10001).where(current_status_id: delayed).order("id desc")

    @app_features = AppFeatureRequest.where(app_feature_type_id: 10000).where.not(current_status_id: others).order("id desc")
    @app_errors = AppFeatureRequest.where(app_feature_type_id: 10001).where.not(current_status_id: others).order("id desc")
    
    
    @app_recent_completed_features = AppFeatureRequest.where(app_feature_type_id: 10000, current_status_id: 10012).order("updated_at desc").limit(10)
    @app_recent_completed_errors = AppFeatureRequest.where(app_feature_type_id: 10001, current_status_id: 10012).order("updated_at desc").limit(10)
    
    @app_completed_features = AppFeatureRequest.where(app_feature_type_id: 10000, current_status_id: 10012).order("actual_completion_date desc").limit(100)
    @app_completed_errors = AppFeatureRequest.where(app_feature_type_id: 10001, current_status_id: 10012).order("actual_completion_date desc").limit(100)

    @display_level = AppCommentDisplayLevel.all
  end
  
  def live_features
    
    @app_completed_features = AppFeatureRequest.where(app_feature_type_id: 10000, current_status_id: 10012).order("actual_completion_date desc")
    @app_completed_errors = AppFeatureRequest.where(app_feature_type_id: 10001, current_status_id: 10012).order("actual_completion_date desc")
    
  end

  # GET /app_feature_requests/1
  # GET /app_feature_requests/1.json
  def show
    
    @feature_comments = AppFeatureComment.where(app_feature_request_id: @app_feature_request.id, display_level_id: 10000)
    @private_feature_comments = AppFeatureComment.where(app_feature_request_id: @app_feature_request.id, display_level_id: 10001, comments_by_id: @employee_id)

    @comment_types = AppCommentType.all.order(:priority_no)
    @display_level = AppCommentDisplayLevel.all.order(:priority_no)

    @app_feature_comment = AppFeatureComment.new(app_feature_request_id: @app_feature_request.id, :comments_by_id => @employee_id)

    @app_stage_feature_comment = AppFeatureComment.new(app_feature_request_id: @app_feature_request.id, :comments_by_id => @employee_id, display_level_id: 10000, comment_type_id: 10020)

    @current_stage_id = @app_feature_request.current_status_id
    @close_ticket_id = 10012
    @next_stage_id = next_stage_id @current_stage_id
    @new_stage = AppStatus.find(@next_stage_id)
    @panel_heading = "Shift this tickets as: #{@new_stage.description}"
    @button_name = "Click: #{@new_stage.name}"
      #@new_stage_id =
  end

  # GET /app_feature_requests/new
  def new
   
    #@app_current_status
    #@app_velocity
    @host = request.host
    @app_feature_type = AppFeatureType.all.order(:priority_no)
    @app_list = AppList.all.order(:priority_no)
    @app_priorities = AppPriority.all.order(:priority_no)
    @app_feature_request = AppFeatureRequest.new(request_by: @employee_id, current_status_id: 10000, velocity_id: 10000) #(require_by_date: Date.today + 7.days)
    @allow_edit = 1
  end

  # GET /app_feature_requests/1/edit
  def edit
    
    developer_list = [10022]
    @employees = Employee.all.order("first_name").joins(:employee_role).where("employee_roles.sortorder < 10")
    @developers = Employee.all.order("first_name").where(employee_role_id: developer_list)
    @app_feature_type = AppFeatureType.all.order(:priority_no)
    @app_list = AppList.all.order(:priority_no)
    @app_priorities = AppPriority.all.order(:priority_no)
    @app_current_status = AppStatus.all.order(:priority_no)
    @app_velocity = AppVelocity.all.order(:priority_no)
  #  @app_priorities = AppPriority.all.order(:priority_no)

  end

  # POST /app_feature_requests
  # POST /app_feature_requests.json
  def create
   
    @app_feature_request = AppFeatureRequest.new(app_feature_request_params)
    #06/02/2016
    respond_to do |format|
      if @app_feature_request.save

        #  AppMailer.test_email("deepesh@tec2grow.com", @app_feature_request).deliver_now

        if current_user.role == 10022
          format.html {redirect_to app_feature_requests_path, notice: "Request was successfully created with id: #{@app_feature_request.id}"  }
        else
          @employee = Employee.find(@app_feature_request.request_by)
          AppMailer.new_ticket(@employee.emailid, @app_feature_request) if @employee.emailid.present?
          # .deliver_now
          AppMailer.new_ticket("deepesh@tec2grow.com", @app_feature_request).deliver_now
        end

        format.html {redirect_to root_path, notice: "Request was successfully created with id: #{@app_feature_request.id}"  }
        format.json { render :show, status: :created, location: @app_feature_request }
      else
        format.html { render :new }
        format.json { render json: @app_feature_request.errors, status: :unprocessable_entity }
      end
    end
  end



  # PATCH/PUT /app_feature_requests/1
  # PATCH/PUT /app_feature_requests/1.json
  def update
 
    respond_to do |format|
      if @app_feature_request.update(app_feature_request_params)
        @app_feature_request.update_date
        if current_user.role == 10022
          format.html {redirect_to app_feature_requests_path, notice: "Request id: #{@app_feature_request.id} was successfully updated "  }
        # else
        #   AppMailer.updated("deepesh@tec2grow.com", @app_feature_request).deliver_now
        end
        if @app_feature_request.current_status_id == 10010 # update pending
          @employees = Employee.where(employee_role_id: 10162) #send alerts to tec support to upload
          @employees.each do |empl|
            AppMailer.upload(empl.emailid, @app_feature_request).deliver_now if empl.emailid.present?
          end
        end
        
        if @app_feature_request.current_status_id == 10003 # Need error logs or more information pending
          @employees = Employee.where(employee_role_id: 10162) #send alerts to tec support to upload
          @employees.each do |empl|
            AppMailer.log(empl.emailid, @app_feature_request).deliver_now if empl.emailid.present?
          end
        end

        if @app_feature_request.current_status_id == 10008 # checking required
          @employee = Employee.find(@app_feature_request.request_by)
          AppMailer.check(@employee.emailid, @app_feature_request).deliver_now if @employee.emailid.present?
        end

        if @app_feature_request.current_status_id == 10012 # live
          @employee = Employee.find(@app_feature_request.request_by)
            AppMailer.feature_live(@employee.emailid, @app_feature_request).deliver_now if @employee.emailid.present?
        end

        format.html { redirect_to root_path, notice: 'Feature request was successfully updated.' }
        format.json { render :show, status: :ok, location: @app_feature_request }
      else
        format.html { render :edit }
        format.json { render json: @app_feature_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_feature_requests/1
  # DELETE /app_feature_requests/1.json
  def destroy
    @app_feature_request.destroy
    respond_to do |format|
      format.html { redirect_to app_feature_requests_path, notice: 'Feature request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def employee_id
      @host = request.host
      @empcode = current_user.employee_code
      @employee = Employee.where(employeecode: @empcode)
      @employee_id = @employee.first.id
    end
    def current_time
        @current_time = (Time.zone.now + 330.minutes)
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_app_feature_request
      @app_feature_request = AppFeatureRequest.find(params[:id])
    end
    def show_edit
      @closed_no_edit, @allow_edit, @show_all_details, @allow_comments = 0,0,0,0
      if @app_feature_request.present?
        if (current_user.employee_code == @app_feature_request.employee.employeecode) || (current_user.employee_role.sortorder < 5)
          @show_all_details = 1
        end
        #@allow_comments

       if  (current_user.employee_code == @app_feature_request.employee.employeecode) || (current_user.employee_role.sortorder < 5) ||
         (@app_feature_request.app_status.priority_no < 11)
         @allow_comments = 1
         @allow_edit = 1
       end
       if @app_feature_request.app_status.priority_no > 11
          @closed_no_edit = 1
       end
       if current_user.role == 10022
          @allow_edit = 1
          @closed_no_edit = 1
       end
       
       
      end
    end
    
    def next_stage_id stage_id
      final_stage = 10012
        case stage_id # a_variable is the variable we want to compare
          when 10008    #testing sought
            final_stage = 10010
          when 10003
            final_stage = 10004
          when 10010   #compare to 1
            final_stage = 10012
        end
        return final_stage
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def app_feature_request_params
      params.require(:app_feature_request).permit(:name, :app_id, :app_feature_type_id, :problem_this_solves, :mandatory_requirements, :technical_notes, :request_by, :require_by_date, :estimated_completion_date, :actual_completion_date, :user_approved_date, :user_satisfaction_level_id, :velocity_id, :current_status_id, :priority_id, :assigned_to, :extra_notes, :tables_used, :estimated_hours, :actual_hours, :bug_count, :linked_app_feature_id, :queue_no, :comment_count, :user_image)
    end
end
