require 'test_helper'

class SalesPposControllerTest < ActionController::TestCase
  setup do
    @sales_ppo = sales_ppos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sales_ppos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sales_ppo" do
    assert_difference('SalesPpo.count') do
      post :create, sales_ppo: { campaign_id: @sales_ppo.campaign_id, campaign_playlist_id: @sales_ppo.campaign_playlist_id, city: @sales_ppo.city, commission_cost: @sales_ppo.commission_cost, damages: @sales_ppo.damages, dnis: @sales_ppo.dnis, external_order_no: @sales_ppo.external_order_no, gross_sales: @sales_ppo.gross_sales, media_cost: @sales_ppo.media_cost, media_cost_total: @sales_ppo.media_cost_total, media_id: @sales_ppo.media_id, mobile_no: @sales_ppo.mobile_no, name: @sales_ppo.name, net_sale: @sales_ppo.net_sale, order_id: @sales_ppo.order_id, order_last_mile_id: @sales_ppo.order_last_mile_id, order_line_id: @sales_ppo.order_line_id, order_pincode: @sales_ppo.order_pincode, order_status_id: @sales_ppo.order_status_id, pieces: @sales_ppo.pieces, prod: @sales_ppo.prod, product_cost: @sales_ppo.product_cost, product_list_id: @sales_ppo.product_list_id, product_master_id: @sales_ppo.product_master_id, product_variant_id: @sales_ppo.product_variant_id, promo_cost_total: @sales_ppo.promo_cost_total, promotion_cost: @sales_ppo.promotion_cost, returns: @sales_ppo.returns, revenue: @sales_ppo.revenue, start_time: @sales_ppo.start_time, state: @sales_ppo.state }
    end

    assert_redirected_to sales_ppo_path(assigns(:sales_ppo))
  end

  test "should show sales_ppo" do
    get :show, id: @sales_ppo
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sales_ppo
    assert_response :success
  end

  test "should update sales_ppo" do
    patch :update, id: @sales_ppo, sales_ppo: { campaign_id: @sales_ppo.campaign_id, campaign_playlist_id: @sales_ppo.campaign_playlist_id, city: @sales_ppo.city, commission_cost: @sales_ppo.commission_cost, damages: @sales_ppo.damages, dnis: @sales_ppo.dnis, external_order_no: @sales_ppo.external_order_no, gross_sales: @sales_ppo.gross_sales, media_cost: @sales_ppo.media_cost, media_cost_total: @sales_ppo.media_cost_total, media_id: @sales_ppo.media_id, mobile_no: @sales_ppo.mobile_no, name: @sales_ppo.name, net_sale: @sales_ppo.net_sale, order_id: @sales_ppo.order_id, order_last_mile_id: @sales_ppo.order_last_mile_id, order_line_id: @sales_ppo.order_line_id, order_pincode: @sales_ppo.order_pincode, order_status_id: @sales_ppo.order_status_id, pieces: @sales_ppo.pieces, prod: @sales_ppo.prod, product_cost: @sales_ppo.product_cost, product_list_id: @sales_ppo.product_list_id, product_master_id: @sales_ppo.product_master_id, product_variant_id: @sales_ppo.product_variant_id, promo_cost_total: @sales_ppo.promo_cost_total, promotion_cost: @sales_ppo.promotion_cost, returns: @sales_ppo.returns, revenue: @sales_ppo.revenue, start_time: @sales_ppo.start_time, state: @sales_ppo.state }
    assert_redirected_to sales_ppo_path(assigns(:sales_ppo))
  end

  test "should destroy sales_ppo" do
    assert_difference('SalesPpo.count', -1) do
      delete :destroy, id: @sales_ppo
    end

    assert_redirected_to sales_ppos_path
  end
end
