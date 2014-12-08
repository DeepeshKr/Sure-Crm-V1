require 'test_helper'

class CampaignStagesControllerTest < ActionController::TestCase
  setup do
    @campaign_stage = campaign_stages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:campaign_stages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create campaign_stage" do
    assert_difference('CampaignStage.count') do
      post :create, campaign_stage: { name: @campaign_stage.name, sortorder: @campaign_stage.sortorder }
    end

    assert_redirected_to campaign_stage_path(assigns(:campaign_stage))
  end

  test "should show campaign_stage" do
    get :show, id: @campaign_stage
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @campaign_stage
    assert_response :success
  end

  test "should update campaign_stage" do
    patch :update, id: @campaign_stage, campaign_stage: { name: @campaign_stage.name, sortorder: @campaign_stage.sortorder }
    assert_redirected_to campaign_stage_path(assigns(:campaign_stage))
  end

  test "should destroy campaign_stage" do
    assert_difference('CampaignStage.count', -1) do
      delete :destroy, id: @campaign_stage
    end

    assert_redirected_to campaign_stages_path
  end
end
