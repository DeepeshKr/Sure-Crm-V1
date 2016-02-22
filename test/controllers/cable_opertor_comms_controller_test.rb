require 'test_helper'

class CableOpertorCommsControllerTest < ActionController::TestCase
  setup do
    @cable_opertor_comm = cable_opertor_comms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cable_opertor_comms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cable_opertor_comm" do
    assert_difference('CableOpertorComm.count') do
      post :create, cable_opertor_comm: { amount: @cable_opertor_comm.amount, channel: @cable_opertor_comm.channel, city: @cable_opertor_comm.city, comm: @cable_opertor_comm.comm, customer_name: @cable_opertor_comm.customer_name, description: @cable_opertor_comm.description, order_date: @cable_opertor_comm.order_date, order_no: @cable_opertor_comm.order_no, product: @cable_opertor_comm.product }
    end

    assert_redirected_to cable_opertor_comm_path(assigns(:cable_opertor_comm))
  end

  test "should show cable_opertor_comm" do
    get :show, id: @cable_opertor_comm
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cable_opertor_comm
    assert_response :success
  end

  test "should update cable_opertor_comm" do
    patch :update, id: @cable_opertor_comm, cable_opertor_comm: { amount: @cable_opertor_comm.amount, channel: @cable_opertor_comm.channel, city: @cable_opertor_comm.city, comm: @cable_opertor_comm.comm, customer_name: @cable_opertor_comm.customer_name, description: @cable_opertor_comm.description, order_date: @cable_opertor_comm.order_date, order_no: @cable_opertor_comm.order_no, product: @cable_opertor_comm.product }
    assert_redirected_to cable_opertor_comm_path(assigns(:cable_opertor_comm))
  end

  test "should destroy cable_opertor_comm" do
    assert_difference('CableOpertorComm.count', -1) do
      delete :destroy, id: @cable_opertor_comm
    end

    assert_redirected_to cable_opertor_comms_path
  end
end
