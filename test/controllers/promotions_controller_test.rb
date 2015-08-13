require 'test_helper'

class PromotionsControllerTest < ActionController::TestCase
  setup do
    @promotion = promotions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:promotions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create promotion" do
    assert_difference('Promotion.count') do
      post :create, promotion: { active: @promotion.active, description: @promotion.description, discount_percent: @promotion.discount_percent, discount_value: @promotion.discount_value, end_date: @promotion.end_date, end_hr: @promotion.end_hr, end_min: @promotion.end_min, free_product_list_id: @promotion.free_product_list_id, media_id: @promotion.media_id, min_sale_value: @promotion.min_sale_value, name: @promotion.name, promo_cost: @promotion.promo_cost, start_date: @promotion.start_date, start_hr: @promotion.start_hr, start_min: @promotion.start_min, unique_code: @promotion.unique_code }
    end

    assert_redirected_to promotion_path(assigns(:promotion))
  end

  test "should show promotion" do
    get :show, id: @promotion
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @promotion
    assert_response :success
  end

  test "should update promotion" do
    patch :update, id: @promotion, promotion: { active: @promotion.active, description: @promotion.description, discount_percent: @promotion.discount_percent, discount_value: @promotion.discount_value, end_date: @promotion.end_date, end_hr: @promotion.end_hr, end_min: @promotion.end_min, free_product_list_id: @promotion.free_product_list_id, media_id: @promotion.media_id, min_sale_value: @promotion.min_sale_value, name: @promotion.name, promo_cost: @promotion.promo_cost, start_date: @promotion.start_date, start_hr: @promotion.start_hr, start_min: @promotion.start_min, unique_code: @promotion.unique_code }
    assert_redirected_to promotion_path(assigns(:promotion))
  end

  test "should destroy promotion" do
    assert_difference('Promotion.count', -1) do
      delete :destroy, id: @promotion
    end

    assert_redirected_to promotions_path
  end
end
