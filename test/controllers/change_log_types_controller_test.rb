require 'test_helper'

class ChangeLogTypesControllerTest < ActionController::TestCase
  setup do
    @change_log_type = change_log_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:change_log_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create change_log_type" do
    assert_difference('ChangeLogType.count') do
      post :create, change_log_type: { description: @change_log_type.description, name: @change_log_type.name }
    end

    assert_redirected_to change_log_type_path(assigns(:change_log_type))
  end

  test "should show change_log_type" do
    get :show, id: @change_log_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @change_log_type
    assert_response :success
  end

  test "should update change_log_type" do
    patch :update, id: @change_log_type, change_log_type: { description: @change_log_type.description, name: @change_log_type.name }
    assert_redirected_to change_log_type_path(assigns(:change_log_type))
  end

  test "should destroy change_log_type" do
    assert_difference('ChangeLogType.count', -1) do
      delete :destroy, id: @change_log_type
    end

    assert_redirected_to change_log_types_path
  end
end
