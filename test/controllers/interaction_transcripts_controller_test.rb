require 'test_helper'

class InteractionTranscriptsControllerTest < ActionController::TestCase
  setup do
    @interaction_transcript = interaction_transcripts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:interaction_transcripts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create interaction_transcript" do
    assert_difference('InteractionTranscript.count') do
      post :create, interaction_transcript: { description: @interaction_transcript.description, interactionid: @interaction_transcript.interactionid, interactionuserid: @interaction_transcript.interactionuserid }
    end

    assert_redirected_to interaction_transcript_path(assigns(:interaction_transcript))
  end

  test "should show interaction_transcript" do
    get :show, id: @interaction_transcript
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @interaction_transcript
    assert_response :success
  end

  test "should update interaction_transcript" do
    patch :update, id: @interaction_transcript, interaction_transcript: { description: @interaction_transcript.description, interactionid: @interaction_transcript.interactionid, interactionuserid: @interaction_transcript.interactionuserid }
    assert_redirected_to interaction_transcript_path(assigns(:interaction_transcript))
  end

  test "should destroy interaction_transcript" do
    assert_difference('InteractionTranscript.count', -1) do
      delete :destroy, id: @interaction_transcript
    end

    assert_redirected_to interaction_transcripts_path
  end
end
