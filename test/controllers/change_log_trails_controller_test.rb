require 'test_helper'

class ChangeLogTrailsControllerTest < ActionController::TestCase
  setup do
    @change_log_trail = change_log_trails(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:change_log_trails)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create change_log_trail" do
    assert_difference('ChangeLogTrail.count') do
      post :create, change_log_trail: { changelogtype_id: @change_log_trail.changelogtype_id, description: @change_log_trail.description, ip: @change_log_trail.ip, name: @change_log_trail.name, refid: @change_log_trail.refid, username: @change_log_trail.username }
    end

    assert_redirected_to change_log_trail_path(assigns(:change_log_trail))
  end

  test "should show change_log_trail" do
    get :show, id: @change_log_trail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @change_log_trail
    assert_response :success
  end

  test "should update change_log_trail" do
    patch :update, id: @change_log_trail, change_log_trail: { changelogtype_id: @change_log_trail.changelogtype_id, description: @change_log_trail.description, ip: @change_log_trail.ip, name: @change_log_trail.name, refid: @change_log_trail.refid, username: @change_log_trail.username }
    assert_redirected_to change_log_trail_path(assigns(:change_log_trail))
  end

  test "should destroy change_log_trail" do
    assert_difference('ChangeLogTrail.count', -1) do
      delete :destroy, id: @change_log_trail
    end

    assert_redirected_to change_log_trails_path
  end
end
