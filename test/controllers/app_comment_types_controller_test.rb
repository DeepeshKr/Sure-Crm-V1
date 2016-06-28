require 'test_helper'

class AppCommentTypesControllerTest < ActionController::TestCase
  setup do
    @app_comment_type = app_comment_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:app_comment_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create app_comment_type" do
    assert_difference('AppCommentType.count') do
      post :create, app_comment_type: { description: @app_comment_type.description, name: @app_comment_type.name, priority_no: @app_comment_type.priority_no }
    end

    assert_redirected_to app_comment_type_path(assigns(:app_comment_type))
  end

  test "should show app_comment_type" do
    get :show, id: @app_comment_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @app_comment_type
    assert_response :success
  end

  test "should update app_comment_type" do
    patch :update, id: @app_comment_type, app_comment_type: { description: @app_comment_type.description, name: @app_comment_type.name, priority_no: @app_comment_type.priority_no }
    assert_redirected_to app_comment_type_path(assigns(:app_comment_type))
  end

  test "should destroy app_comment_type" do
    assert_difference('AppCommentType.count', -1) do
      delete :destroy, id: @app_comment_type
    end

    assert_redirected_to app_comment_types_path
  end
end
