require 'test_helper'

class MessageTypesControllerTest < ActionController::TestCase
  setup do
    @message_type = message_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:message_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create message_type" do
    assert_difference('MessageType.count') do
      post :create, message_type: { description: @message_type.description, name: @message_type.name, sort_order: @message_type.sort_order }
    end

    assert_redirected_to message_type_path(assigns(:message_type))
  end

  test "should show message_type" do
    get :show, id: @message_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @message_type
    assert_response :success
  end

  test "should update message_type" do
    patch :update, id: @message_type, message_type: { description: @message_type.description, name: @message_type.name, sort_order: @message_type.sort_order }
    assert_redirected_to message_type_path(assigns(:message_type))
  end

  test "should destroy message_type" do
    assert_difference('MessageType.count', -1) do
      delete :destroy, id: @message_type
    end

    assert_redirected_to message_types_path
  end
end
