require 'test_helper'

class MessageStatusesControllerTest < ActionController::TestCase
  setup do
    @message_status = message_statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:message_statuses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create message_status" do
    assert_difference('MessageStatus.count') do
      post :create, message_status: { description: @message_status.description, name: @message_status.name, sort_order: @message_status.sort_order }
    end

    assert_redirected_to message_status_path(assigns(:message_status))
  end

  test "should show message_status" do
    get :show, id: @message_status
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @message_status
    assert_response :success
  end

  test "should update message_status" do
    patch :update, id: @message_status, message_status: { description: @message_status.description, name: @message_status.name, sort_order: @message_status.sort_order }
    assert_redirected_to message_status_path(assigns(:message_status))
  end

  test "should destroy message_status" do
    assert_difference('MessageStatus.count', -1) do
      delete :destroy, id: @message_status
    end

    assert_redirected_to message_statuses_path
  end
end
