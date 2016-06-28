require 'test_helper'

class AppUserSatisfactionLevelsControllerTest < ActionController::TestCase
  setup do
    @app_user_satisfaction_level = app_user_satisfaction_levels(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:app_user_satisfaction_levels)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create app_user_satisfaction_level" do
    assert_difference('AppUserSatisfactionLevel.count') do
      post :create, app_user_satisfaction_level: { description: @app_user_satisfaction_level.description, name: @app_user_satisfaction_level.name, priority_no: @app_user_satisfaction_level.priority_no }
    end

    assert_redirected_to app_user_satisfaction_level_path(assigns(:app_user_satisfaction_level))
  end

  test "should show app_user_satisfaction_level" do
    get :show, id: @app_user_satisfaction_level
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @app_user_satisfaction_level
    assert_response :success
  end

  test "should update app_user_satisfaction_level" do
    patch :update, id: @app_user_satisfaction_level, app_user_satisfaction_level: { description: @app_user_satisfaction_level.description, name: @app_user_satisfaction_level.name, priority_no: @app_user_satisfaction_level.priority_no }
    assert_redirected_to app_user_satisfaction_level_path(assigns(:app_user_satisfaction_level))
  end

  test "should destroy app_user_satisfaction_level" do
    assert_difference('AppUserSatisfactionLevel.count', -1) do
      delete :destroy, id: @app_user_satisfaction_level
    end

    assert_redirected_to app_user_satisfaction_levels_path
  end
end
