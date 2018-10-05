require 'test_helper'

class MarketingMessagesControllerTest < ActionController::TestCase
  setup do
    @marketing_message = marketing_messages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:marketing_messages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create marketing_message" do
    assert_difference('MarketingMessage.count') do
      post :create, marketing_message: { activate: @marketing_message.activate, description: @marketing_message.description, end_date: @marketing_message.end_date, name: @marketing_message.name, order_paymentmodeid: @marketing_message.order_paymentmodeid, start_date: @marketing_message.start_date, total_nos: @marketing_message.total_nos }
    end

    assert_redirected_to marketing_message_path(assigns(:marketing_message))
  end

  test "should show marketing_message" do
    get :show, id: @marketing_message
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @marketing_message
    assert_response :success
  end

  test "should update marketing_message" do
    patch :update, id: @marketing_message, marketing_message: { activate: @marketing_message.activate, description: @marketing_message.description, end_date: @marketing_message.end_date, name: @marketing_message.name, order_paymentmodeid: @marketing_message.order_paymentmodeid, start_date: @marketing_message.start_date, total_nos: @marketing_message.total_nos }
    assert_redirected_to marketing_message_path(assigns(:marketing_message))
  end

  test "should destroy marketing_message" do
    assert_difference('MarketingMessage.count', -1) do
      delete :destroy, id: @marketing_message
    end

    assert_redirected_to marketing_messages_path
  end
end
