require 'test_helper'

class DistributorStockLedgerTypesControllerTest < ActionController::TestCase
  setup do
    @distributor_stock_ledger_type = distributor_stock_ledger_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:distributor_stock_ledger_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create distributor_stock_ledger_type" do
    assert_difference('DistributorStockLedgerType.count') do
      post :create, distributor_stock_ledger_type: { description: @distributor_stock_ledger_type.description, name: @distributor_stock_ledger_type.name, sort_order: @distributor_stock_ledger_type.sort_order }
    end

    assert_redirected_to distributor_stock_ledger_type_path(assigns(:distributor_stock_ledger_type))
  end

  test "should show distributor_stock_ledger_type" do
    get :show, id: @distributor_stock_ledger_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @distributor_stock_ledger_type
    assert_response :success
  end

  test "should update distributor_stock_ledger_type" do
    patch :update, id: @distributor_stock_ledger_type, distributor_stock_ledger_type: { description: @distributor_stock_ledger_type.description, name: @distributor_stock_ledger_type.name, sort_order: @distributor_stock_ledger_type.sort_order }
    assert_redirected_to distributor_stock_ledger_type_path(assigns(:distributor_stock_ledger_type))
  end

  test "should destroy distributor_stock_ledger_type" do
    assert_difference('DistributorStockLedgerType.count', -1) do
      delete :destroy, id: @distributor_stock_ledger_type
    end

    assert_redirected_to distributor_stock_ledger_types_path
  end
end
