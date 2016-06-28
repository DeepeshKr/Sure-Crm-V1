require 'test_helper'

class AppFeatureTypesControllerTest < ActionController::TestCase
  setup do
    @app_feature_type = app_feature_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:app_feature_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create app_feature_type" do
    assert_difference('AppFeatureType.count') do
      post :create, app_feature_type: { description: @app_feature_type.description, name: @app_feature_type.name, priority_no: @app_feature_type.priority_no }
    end

    assert_redirected_to app_feature_type_path(assigns(:app_feature_type))
  end

  test "should show app_feature_type" do
    get :show, id: @app_feature_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @app_feature_type
    assert_response :success
  end

  test "should update app_feature_type" do
    patch :update, id: @app_feature_type, app_feature_type: { description: @app_feature_type.description, name: @app_feature_type.name, priority_no: @app_feature_type.priority_no }
    assert_redirected_to app_feature_type_path(assigns(:app_feature_type))
  end

  test "should destroy app_feature_type" do
    assert_difference('AppFeatureType.count', -1) do
      delete :destroy, id: @app_feature_type
    end

    assert_redirected_to app_feature_types_path
  end
end
