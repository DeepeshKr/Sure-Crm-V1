require 'test_helper'

class CampaignPlayListStatusesControllerTest < ActionController::TestCase
  setup do
    @campaign_play_list_status = campaign_play_list_statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:campaign_play_list_statuses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create campaign_play_list_status" do
    assert_difference('CampaignPlayListStatus.count') do
      post :create, campaign_play_list_status: { description: @campaign_play_list_status.description, name: @campaign_play_list_status.name }
    end

    assert_redirected_to campaign_play_list_status_path(assigns(:campaign_play_list_status))
  end

  test "should show campaign_play_list_status" do
    get :show, id: @campaign_play_list_status
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @campaign_play_list_status
    assert_response :success
  end

  test "should update campaign_play_list_status" do
    patch :update, id: @campaign_play_list_status, campaign_play_list_status: { description: @campaign_play_list_status.description, name: @campaign_play_list_status.name }
    assert_redirected_to campaign_play_list_status_path(assigns(:campaign_play_list_status))
  end

  test "should destroy campaign_play_list_status" do
    assert_difference('CampaignPlayListStatus.count', -1) do
      delete :destroy, id: @campaign_play_list_status
    end

    assert_redirected_to campaign_play_list_statuses_path
  end
end
