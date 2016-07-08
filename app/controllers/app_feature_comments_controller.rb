class AppFeatureCommentsController < ApplicationController
  before_action { protect_controllers(11) }
  before_action :set_app_feature_comment, only: [:show, :edit, :update, :destroy]
  before_action :employee_id

  # GET /app_feature_comments
  # GET /app_feature_comments.json
  def index
    @app_feature_comments = AppFeatureComment.all
  end

  # GET /app_feature_comments/1
  # GET /app_feature_comments/1.json
  def show
  end

  # GET /app_feature_comments/new
  def new
    @app_feature_comment = AppFeatureComment.new
  end

  # GET /app_feature_comments/1/edit
  def edit
  end

  # POST /app_feature_comments
  # POST /app_feature_comments.json
  def create
    @app_feature_comment = AppFeatureComment.new(app_feature_comment_params)

    respond_to do |format|
      if @app_feature_comment.save
        if params[:app_feature_comment][:current_stage_id].present?
            @app_feature_request = AppFeatureRequest.find(@app_feature_comment.app_feature_request_id)
            @employee = Employee.find(@app_feature_request.request_by)
          if @app_feature_request.current_status_id == 10010 # live
            @new_stage_id = params[:app_feature_comment][:new_stage_id]
            @app_feature_request.update(current_status_id: @new_stage_id)
            AppMailer.feature_live(@employee.emailid, @app_feature_request).deliver_now if @employee.emailid.present?
          end
        else
          @app_feature_request = AppFeatureRequest.find(@app_feature_comment.app_feature_request_id)
          @employee = Employee.find(@app_feature_request.request_by)
          AppMailer.delay(:queue => 'emailing').new_comment(@employee.emailid, @app_feature_comment).deliver_now if @employee.emailid.present?
          if current_user.role != 10022
            AppMailer.delay(:queue => 'emailing').new_comment("deepesh@tec2grow.com", @app_feature_comment).deliver_now
          end
        end
        # if @app_feature_comment.app_feature_request.current_status_id == 10008 # check feature
        #   @app_feature_request = AppFeatureRequest.find(@app_feature_comment.app_feature_request_id)
        #   @employee = Employee.find(@app_feature_request.request_by)
        #
        #   AppMailer.updated(@employee.emailid, @app_feature_request).deliver_now if @employee.emailid.present?
        #end
          if (current_user.id == @employee_id) || current_user.role == 10022
            format.html {redirect_to @app_feature_comment.app_feature_request, notice: "Request id: #{@app_feature_request.id} was successfully added"  }
          # elsif
          #   format.html {redirect_to @app_feature_comment.app_feature_request, notice: "Request id: #{@app_feature_request.id} was successfully added"  }
          else
              format.html { redirect_to root_path, notice: "Request id: #{@app_feature_request.id} was successfully added"  }
          end

        format.json { render :show, status: :created, location: @app_feature_comment }
      else
        format.html { render :new }
        format.json { render json: @app_feature_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_feature_comments/1
  # PATCH/PUT /app_feature_comments/1.json
  def update
    respond_to do |format|
      if @app_feature_comment.update(app_feature_comment_params)

        if @app_feature_comment.app_feature_request.current_status_id == 10008 # live
          @app_feature_request = AppFeatureRequest.find(@app_feature_comment.app_feature_request_id)
          @employee = Employee.find(@app_feature_request.request_by)
          AppMailer.updated(@employee.emailid, @app_feature_request).deliver_now if @employee.emailid.present?
        end

        if @app_feature_comment.app_feature_request.current_status_id == 10012 # live
          @app_feature_request = AppFeatureRequest.find(@app_feature_comment.app_feature_request_id)
          @employee = Employee.find(@app_feature_request.request_by)
          AppMailer.updated(@employee.emailid, @app_feature_request).deliver_now if @employee.emailid.present?
        end

        if (current_user.id == @employee_id)
          format.html {redirect_to @app_feature_comment.app_feature_request, notice: "Request id: #{@app_feature_request.id} was successfully updated "  }
        elsif current_user.role == 10022
          format.html {redirect_to @app_feature_comment.app_feature_request, notice: "Request id: #{@app_feature_request.id} was successfully updated "  }
        else
            format.html { redirect_to root_path, notice: "Request id: #{@app_feature_request.id} was successfully updated"  }
        end

        format.json { render :show, status: :ok, location: @app_feature_comment }
      else
        format.html { render :edit }
        format.json { render json: @app_feature_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_feature_comments/1
  # DELETE /app_feature_comments/1.json
  def destroy
    @app_feature_comment.destroy
    respond_to do |format|
      format.html { redirect_to app_feature_comments_url, notice: 'App feature comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def employee_id
      @empcode = current_user.employee_code
      @employee_id = Employee.where(employeecode: @empcode).first.id
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_app_feature_comment
      @app_feature_comment = AppFeatureComment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def app_feature_comment_params
      params.require(:app_feature_comment).permit(:details, :app_feature_request_id, :comments_by_id, :comment_type_id, :display_level_id )
    end
end
