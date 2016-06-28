require 'test_helper'

class AppCommentDisplayLevelsControllerTest < ActionController::TestCase
  setup do
    @app_comment_display_level = app_comment_display_levels(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:app_comment_display_levels)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create app_comment_display_level" do
    assert_difference('AppCommentDisplayLevel.count') do
      post :create, app_comment_display_level: { description: @app_comment_display_level.description, name: @app_comment_display_level.name, priority_no: @app_comment_display_level.priority_no }
    end

    assert_redirected_to app_comment_display_level_path(assigns(:app_comment_display_level))
  end

  test "should show app_comment_display_level" do
    get :show, id: @app_comment_display_level
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @app_comment_display_level
    assert_response :success
  end

  test "should update app_comment_display_level" do
    patch :update, id: @app_comment_display_level, app_comment_display_level: { description: @app_comment_display_level.description, name: @app_comment_display_level.name, priority_no: @app_comment_display_level.priority_no }
    assert_redirected_to app_comment_display_level_path(assigns(:app_comment_display_level))
  end

  test "should destroy app_comment_display_level" do
    assert_difference('AppCommentDisplayLevel.count', -1) do
      delete :destroy, id: @app_comment_display_level
    end

    assert_redirected_to app_comment_display_levels_path
  end
end
