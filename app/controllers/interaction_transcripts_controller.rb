class InteractionTranscriptsController < ApplicationController
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

    description = interaction_transcript_params[:description]
    description += "-- update by user: " << current_user.name << " from ip:" << request.remote_ip 
    @interaction_transcript = InteractionTranscript.new(interaction_transcript_params)
    @interaction_transcript.save
    @interaction_transcript.update(description: description)

    interaction_status_id = params[:interaction_status_id]
    interaction_master = InteractionMaster.find(@interaction_transcript.interactionid)
    interaction_master.update(interaction_status_id: interaction_status_id)

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
      params.require(:interaction_transcript).permit(:interactionid, :interactionuserid, :description, :interaction_status_id)
    end
end
