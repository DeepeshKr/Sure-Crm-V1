require 'test_helper'

class DistributorStockSummariesControllerTest < ActionController::TestCase
  setup do
    @distributor_stock_summary = distributor_stock_summaries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:distributor_stock_summaries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create distributor_stock_summary" do
    assert_difference('DistributorStockSummary.count') do
      post :create, distributor_stock_summary: { corporate_id: @distributor_stock_summary.corporate_id, prod: @distributor_stock_summary.prod, product_list_id: @distributor_stock_summary.product_list_id, product_master_id: @distributor_stock_summary.product_master_id, product_variant_id: @distributor_stock_summary.product_variant_id, rupee_balance: @distributor_stock_summary.rupee_balance, stock_balance: @distributor_stock_summary.stock_balance, stock_returned: @distributor_stock_summary.stock_returned, summary_date: @distributor_stock_summary.summary_date }
    end

    assert_redirected_to distributor_stock_summary_path(assigns(:distributor_stock_summary))
  end

  test "should show distributor_stock_summary" do
    get :show, id: @distributor_stock_summary
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @distributor_stock_summary
    assert_response :success
  end

  test "should update distributor_stock_summary" do
    patch :update, id: @distributor_stock_summary, distributor_stock_summary: { corporate_id: @distributor_stock_summary.corporate_id, prod: @distributor_stock_summary.prod, product_list_id: @distributor_stock_summary.product_list_id, product_master_id: @distributor_stock_summary.product_master_id, product_variant_id: @distributor_stock_summary.product_variant_id, rupee_balance: @distributor_stock_summary.rupee_balance, stock_balance: @distributor_stock_summary.stock_balance, stock_returned: @distributor_stock_summary.stock_returned, summary_date: @distributor_stock_summary.summary_date }
    assert_redirected_to distributor_stock_summary_path(assigns(:distributor_stock_summary))
  end

  test "should destroy distributor_stock_summary" do
    assert_difference('DistributorStockSummary.count', -1) do
      delete :destroy, id: @distributor_stock_summary
    end

    assert_redirected_to distributor_stock_summaries_path
  end
end
