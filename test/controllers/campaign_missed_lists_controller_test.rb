require 'test_helper'

class CampaignMissedListsControllerTest < ActionController::TestCase
  setup do
    @campaign_missed_list = campaign_missed_lists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:campaign_missed_lists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create campaign_missed_list" do
    assert_difference('CampaignMissedList.count') do
      post :create, campaign_missed_list: { description: @campaign_missed_list.description, external_prod: @campaign_missed_list.external_prod, product_list_id: @campaign_missed_list.product_list_id, product_variant_id: @campaign_missed_list.product_variant_id, productmaster_id: @campaign_missed_list.productmaster_id, reason: @campaign_missed_list.reason }
    end

    assert_redirected_to campaign_missed_list_path(assigns(:campaign_missed_list))
  end

  test "should show campaign_missed_list" do
    get :show, id: @campaign_missed_list
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @campaign_missed_list
    assert_response :success
  end

  test "should update campaign_missed_list" do
    patch :update, id: @campaign_missed_list, campaign_missed_list: { description: @campaign_missed_list.description, external_prod: @campaign_missed_list.external_prod, product_list_id: @campaign_missed_list.product_list_id, product_variant_id: @campaign_missed_list.product_variant_id, productmaster_id: @campaign_missed_list.productmaster_id, reason: @campaign_missed_list.reason }
    assert_redirected_to campaign_missed_list_path(assigns(:campaign_missed_list))
  end

  test "should destroy campaign_missed_list" do
    assert_difference('CampaignMissedList.count', -1) do
      delete :destroy, id: @campaign_missed_list
    end

    assert_redirected_to campaign_missed_lists_path
  end
end
