require 'test_helper'

class AppListsControllerTest < ActionController::TestCase
  setup do
    @app_list = app_lists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:app_lists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create app_list" do
    assert_difference('AppList.count') do
      post :create, app_list: { description: @app_list.description, location: @app_list.location, name: @app_list.name, primary_goal_of_app: @app_list.primary_goal_of_app, priority_no: @app_list.priority_no, version: @app_list.version }
    end

    assert_redirected_to app_list_path(assigns(:app_list))
  end

  test "should show app_list" do
    get :show, id: @app_list
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @app_list
    assert_response :success
  end

  test "should update app_list" do
    patch :update, id: @app_list, app_list: { description: @app_list.description, location: @app_list.location, name: @app_list.name, primary_goal_of_app: @app_list.primary_goal_of_app, priority_no: @app_list.priority_no, version: @app_list.version }
    assert_redirected_to app_list_path(assigns(:app_list))
  end

  test "should destroy app_list" do
    assert_difference('AppList.count', -1) do
      delete :destroy, id: @app_list
    end

    assert_redirected_to app_lists_path
  end
end
