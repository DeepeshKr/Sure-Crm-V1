require 'test_helper'

class OrderLinesControllerTest < ActionController::TestCase
  setup do
    @order_line = order_lines(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:order_lines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create order_line" do
    assert_difference('OrderLine.count') do
      post :create, order_line: { actualshippate: @order_line.actualshippate, codcharges: @order_line.codcharges, description: @order_line.description, employee_id: @order_line.employee_id, employeecode: @order_line.employeecode, estimatedarrivaldate: @order_line.estimatedarrivaldate, estimatedshipdate: @order_line.estimatedshipdate, external_ref_no: @order_line.external_ref_no, orderchecked: @order_line.orderchecked, orderdate: @order_line.orderdate, orderid: @order_line.orderid, orderlinestatusmaster_id: @order_line.orderlinestatusmaster_id, pieces: @order_line.pieces, productline_id: @order_line.productline_id, productvariant_id: @order_line.productvariant_id, shipping: @order_line.shipping, subtotal: @order_line.subtotal, taxes: @order_line.taxes, total: @order_line.total }
    end

    assert_redirected_to order_line_path(assigns(:order_line))
  end

  test "should show order_line" do
    get :show, id: @order_line
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @order_line
    assert_response :success
  end

  test "should update order_line" do
    patch :update, id: @order_line, order_line: { actualshippate: @order_line.actualshippate, codcharges: @order_line.codcharges, description: @order_line.description, employee_id: @order_line.employee_id, employeecode: @order_line.employeecode, estimatedarrivaldate: @order_line.estimatedarrivaldate, estimatedshipdate: @order_line.estimatedshipdate, external_ref_no: @order_line.external_ref_no, orderchecked: @order_line.orderchecked, orderdate: @order_line.orderdate, orderid: @order_line.orderid, orderlinestatusmaster_id: @order_line.orderlinestatusmaster_id, pieces: @order_line.pieces, productline_id: @order_line.productline_id, productvariant_id: @order_line.productvariant_id, shipping: @order_line.shipping, subtotal: @order_line.subtotal, taxes: @order_line.taxes, total: @order_line.total }
    assert_redirected_to order_line_path(assigns(:order_line))
  end

  test "should destroy order_line" do
    assert_difference('OrderLine.count', -1) do
      delete :destroy, id: @order_line
    end

    assert_redirected_to order_lines_path
  end
end
