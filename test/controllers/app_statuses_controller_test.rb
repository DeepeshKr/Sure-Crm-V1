require 'test_helper'

class AppStatusesControllerTest < ActionController::TestCase
  setup do
    @app_status = app_statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:app_statuses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create app_status" do
    assert_difference('AppStatus.count') do
      post :create, app_status: { description: @app_status.description, name: @app_status.name, priority_no: @app_status.priority_no }
    end

    assert_redirected_to app_status_path(assigns(:app_status))
  end

  test "should show app_status" do
    get :show, id: @app_status
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @app_status
    assert_response :success
  end

  test "should update app_status" do
    patch :update, id: @app_status, app_status: { description: @app_status.description, name: @app_status.name, priority_no: @app_status.priority_no }
    assert_redirected_to app_status_path(assigns(:app_status))
  end

  test "should destroy app_status" do
    assert_difference('AppStatus.count', -1) do
      delete :destroy, id: @app_status
    end

    assert_redirected_to app_statuses_path
  end
end
