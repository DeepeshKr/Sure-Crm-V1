require 'test_helper'

class AppFeatureCommentsControllerTest < ActionController::TestCase
  setup do
    @app_feature_comment = app_feature_comments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:app_feature_comments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create app_feature_comment" do
    assert_difference('AppFeatureComment.count') do
      post :create, app_feature_comment: { app_feature_request_id: @app_feature_comment.app_feature_request_id, comment_type_id: @app_feature_comment.comment_type_id, comments_by_id: @app_feature_comment.comments_by_id, details: @app_feature_comment.details, display_level_id: @app_feature_comment.display_level_id }
    end

    assert_redirected_to app_feature_comment_path(assigns(:app_feature_comment))
  end

  test "should show app_feature_comment" do
    get :show, id: @app_feature_comment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @app_feature_comment
    assert_response :success
  end

  test "should update app_feature_comment" do
    patch :update, id: @app_feature_comment, app_feature_comment: { app_feature_request_id: @app_feature_comment.app_feature_request_id, comment_type_id: @app_feature_comment.comment_type_id, comments_by_id: @app_feature_comment.comments_by_id, details: @app_feature_comment.details, display_level_id: @app_feature_comment.display_level_id }
    assert_redirected_to app_feature_comment_path(assigns(:app_feature_comment))
  end

  test "should destroy app_feature_comment" do
    assert_difference('AppFeatureComment.count', -1) do
      delete :destroy, id: @app_feature_comment
    end

    assert_redirected_to app_feature_comments_path
  end
end
