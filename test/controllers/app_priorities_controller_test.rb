require 'test_helper'

class AppPrioritiesControllerTest < ActionController::TestCase
  setup do
    @app_priority = app_priorities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:app_priorities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create app_priority" do
    assert_difference('AppPriority.count') do
      post :create, app_priority: { description: @app_priority.description, name: @app_priority.name, priority_no: @app_priority.priority_no }
    end

    assert_redirected_to app_priority_path(assigns(:app_priority))
  end

  test "should show app_priority" do
    get :show, id: @app_priority
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @app_priority
    assert_response :success
  end

  test "should update app_priority" do
    patch :update, id: @app_priority, app_priority: { description: @app_priority.description, name: @app_priority.name, priority_no: @app_priority.priority_no }
    assert_redirected_to app_priority_path(assigns(:app_priority))
  end

  test "should destroy app_priority" do
    assert_difference('AppPriority.count', -1) do
      delete :destroy, id: @app_priority
    end

    assert_redirected_to app_priorities_path
  end
end
