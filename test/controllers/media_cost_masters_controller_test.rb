require 'test_helper'

class MediaCostMastersControllerTest < ActionController::TestCase
  setup do
    @media_cost_master = media_cost_masters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:media_cost_masters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create media_cost_master" do
    assert_difference('MediaCostMaster.count') do
      post :create, media_cost_master: { cost_per_sec: @media_cost_master.cost_per_sec, description: @media_cost_master.description, duration_secs: @media_cost_master.duration_secs, end_hr: @media_cost_master.end_hr, end_min: @media_cost_master.end_min, end_sec: @media_cost_master.end_sec, media_id: @media_cost_master.media_id, name: @media_cost_master.name, str_hr: @media_cost_master.str_hr, str_min: @media_cost_master.str_min, str_sec: @media_cost_master.str_sec }
    end

    assert_redirected_to media_cost_master_path(assigns(:media_cost_master))
  end

  test "should show media_cost_master" do
    get :show, id: @media_cost_master
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @media_cost_master
    assert_response :success
  end

  test "should update media_cost_master" do
    patch :update, id: @media_cost_master, media_cost_master: { cost_per_sec: @media_cost_master.cost_per_sec, description: @media_cost_master.description, duration_secs: @media_cost_master.duration_secs, end_hr: @media_cost_master.end_hr, end_min: @media_cost_master.end_min, end_sec: @media_cost_master.end_sec, media_id: @media_cost_master.media_id, name: @media_cost_master.name, str_hr: @media_cost_master.str_hr, str_min: @media_cost_master.str_min, str_sec: @media_cost_master.str_sec }
    assert_redirected_to media_cost_master_path(assigns(:media_cost_master))
  end

  test "should destroy media_cost_master" do
    assert_difference('MediaCostMaster.count', -1) do
      delete :destroy, id: @media_cost_master
    end

    assert_redirected_to media_cost_masters_path
  end
end
