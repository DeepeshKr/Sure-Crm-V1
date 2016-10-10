require 'test_helper'

class CustDetailsTrackLogsControllerTest < ActionController::TestCase
  setup do
    @cust_details_track_log = cust_details_track_logs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cust_details_track_logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cust_details_track_log" do
    assert_difference('CustDetailsTrackLog.count') do
      post :create, cust_details_track_log: { cust_details_track_id: @cust_details_track_log.cust_details_track_id, description: @cust_details_track_log.description, name: @cust_details_track_log.name }
    end

    assert_redirected_to cust_details_track_log_path(assigns(:cust_details_track_log))
  end

  test "should show cust_details_track_log" do
    get :show, id: @cust_details_track_log
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cust_details_track_log
    assert_response :success
  end

  test "should update cust_details_track_log" do
    patch :update, id: @cust_details_track_log, cust_details_track_log: { cust_details_track_id: @cust_details_track_log.cust_details_track_id, description: @cust_details_track_log.description, name: @cust_details_track_log.name }
    assert_redirected_to cust_details_track_log_path(assigns(:cust_details_track_log))
  end

  test "should destroy cust_details_track_log" do
    assert_difference('CustDetailsTrackLog.count', -1) do
      delete :destroy, id: @cust_details_track_log
    end

    assert_redirected_to cust_details_track_logs_path
  end
end
