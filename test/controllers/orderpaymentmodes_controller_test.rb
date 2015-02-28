require 'test_helper'

class OrderpaymentmodesControllerTest < ActionController::TestCase
  setup do
    @orderpaymentmode = orderpaymentmodes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:orderpaymentmodes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create orderpaymentmode" do
    assert_difference('Orderpaymentmode.count') do
      post :create, orderpaymentmode: { description: @orderpaymentmode.description, name: @orderpaymentmode.name }
    end

    assert_redirected_to orderpaymentmode_path(assigns(:orderpaymentmode))
  end

  test "should show orderpaymentmode" do
    get :show, id: @orderpaymentmode
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @orderpaymentmode
    assert_response :success
  end

  test "should update orderpaymentmode" do
    patch :update, id: @orderpaymentmode, orderpaymentmode: { description: @orderpaymentmode.description, name: @orderpaymentmode.name }
    assert_redirected_to orderpaymentmode_path(assigns(:orderpaymentmode))
  end

  test "should destroy orderpaymentmode" do
    assert_difference('Orderpaymentmode.count', -1) do
      delete :destroy, id: @orderpaymentmode
    end

    assert_redirected_to orderpaymentmodes_path
  end
end
