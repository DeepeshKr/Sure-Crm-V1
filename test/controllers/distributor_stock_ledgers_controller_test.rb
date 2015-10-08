require 'test_helper'

class DistributorStockLedgersControllerTest < ActionController::TestCase
  setup do
    @distributor_stock_ledger = distributor_stock_ledgers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:distributor_stock_ledgers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create distributor_stock_ledger" do
    assert_difference('DistributorStockLedger.count') do
      post :create, distributor_stock_ledger: { corporate_id: @distributor_stock_ledger.corporate_id, description: @distributor_stock_ledger.description, ledger_date: @distributor_stock_ledger.ledger_date, name: @distributor_stock_ledger.name, prod: @distributor_stock_ledger.prod, product_list_id: @distributor_stock_ledger.product_list_id, product_master_id: @distributor_stock_ledger.product_master_id, product_variant_id: @distributor_stock_ledger.product_variant_id, stock_change: @distributor_stock_ledger.stock_change }
    end

    assert_redirected_to distributor_stock_ledger_path(assigns(:distributor_stock_ledger))
  end

  test "should show distributor_stock_ledger" do
    get :show, id: @distributor_stock_ledger
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @distributor_stock_ledger
    assert_response :success
  end

  test "should update distributor_stock_ledger" do
    patch :update, id: @distributor_stock_ledger, distributor_stock_ledger: { corporate_id: @distributor_stock_ledger.corporate_id, description: @distributor_stock_ledger.description, ledger_date: @distributor_stock_ledger.ledger_date, name: @distributor_stock_ledger.name, prod: @distributor_stock_ledger.prod, product_list_id: @distributor_stock_ledger.product_list_id, product_master_id: @distributor_stock_ledger.product_master_id, product_variant_id: @distributor_stock_ledger.product_variant_id, stock_change: @distributor_stock_ledger.stock_change }
    assert_redirected_to distributor_stock_ledger_path(assigns(:distributor_stock_ledger))
  end

  test "should destroy distributor_stock_ledger" do
    assert_difference('DistributorStockLedger.count', -1) do
      delete :destroy, id: @distributor_stock_ledger
    end

    assert_redirected_to distributor_stock_ledgers_path
  end
end
