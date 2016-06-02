require 'test_helper'

class CampaignPlaylistToProductsControllerTest < ActionController::TestCase
  setup do
    @campaign_playlist_to_product = campaign_playlist_to_products(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:campaign_playlist_to_products)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create campaign_playlist_to_product" do
    assert_difference('CampaignPlaylistToProduct.count') do
      post :create, campaign_playlist_to_product: { campaign_playlist_id: @campaign_playlist_to_product.campaign_playlist_id, name: @campaign_playlist_to_product.name, product_variant_id: @campaign_playlist_to_product.product_variant_id }
    end

    assert_redirected_to campaign_playlist_to_product_path(assigns(:campaign_playlist_to_product))
  end

  test "should show campaign_playlist_to_product" do
    get :show, id: @campaign_playlist_to_product
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @campaign_playlist_to_product
    assert_response :success
  end

  test "should update campaign_playlist_to_product" do
    patch :update, id: @campaign_playlist_to_product, campaign_playlist_to_product: { campaign_playlist_id: @campaign_playlist_to_product.campaign_playlist_id, name: @campaign_playlist_to_product.name, product_variant_id: @campaign_playlist_to_product.product_variant_id }
    assert_redirected_to campaign_playlist_to_product_path(assigns(:campaign_playlist_to_product))
  end

  test "should destroy campaign_playlist_to_product" do
    assert_difference('CampaignPlaylistToProduct.count', -1) do
      delete :destroy, id: @campaign_playlist_to_product
    end

    assert_redirected_to campaign_playlist_to_products_path
  end
end
