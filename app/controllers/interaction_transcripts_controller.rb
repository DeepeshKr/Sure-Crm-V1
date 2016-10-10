class InteractionTranscriptsController < ApplicationController
    before_action { protect_controllers(12) } 
  before_action :set_interaction_transcript, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @interaction_transcripts = InteractionTranscript.all
    respond_with(@interaction_transcripts)
  end

  def show
    respond_with(@interaction_transcript)
  end

  def new
    @interaction_transcript = InteractionTranscript.new
    respond_with(@interaction_transcript)
  end

  def edit
  end

  def quick_create
    @empcode = current_user.employee_code
      #@empid = current_user.id
    @empid = Employee.where(employeecode: @empcode).first.id
    @interaction_transcript = InteractionTranscript.create(interaction_transcript_params) 
   # interaction_status_id = 
    #interaction_master = InteractionMaster.find(@interaction_transcript.interactionid)
    @interaction_transcript.interaction_master.update_attribute(:interaction_status_id, params[:interaction_status_id])
    @interaction_transcript.interaction_master.update_attribute(:closedon, params[:closedon])

    respond_with(@interaction_transcript.interaction_master)
    
    
  end

  def create
    @interaction_transcript = InteractionTranscript.new(interaction_transcript_params)
    @interaction_transcript.save
    respond_with(@interaction_transcript)
  end

  def update
    @interaction_transcript.update(interaction_transcript_params)
    respond_with(@interaction_transcript)
  end

  def destroy
    @interaction_transcript.destroy
    respond_with(@interaction_transcript)
  end

  private
    def set_interaction_transcript
      @interaction_transcript = InteractionTranscript.find(params[:id])
    end

    def interaction_transcript_params
      params.require(:interaction_transcript).permit(:interactionid, 
        :interactionuserid, :description, :employee_id, :ip)
    end
end
