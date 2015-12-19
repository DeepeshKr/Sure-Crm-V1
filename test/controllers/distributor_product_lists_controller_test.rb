require 'test_helper'

class DistributorProductListsControllerTest < ActionController::TestCase
  setup do
    @distributor_product_list = distributor_product_lists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:distributor_product_lists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create distributor_product_list" do
    assert_difference('DistributorProductList.count') do
      post :create, distributor_product_list: { name: @distributor_product_list.name, product_list_id: @distributor_product_list.product_list_id, sort_order: @distributor_product_list.sort_order }
    end

    assert_redirected_to distributor_product_list_path(assigns(:distributor_product_list))
  end

  test "should show distributor_product_list" do
    get :show, id: @distributor_product_list
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @distributor_product_list
    assert_response :success
  end

  test "should update distributor_product_list" do
    patch :update, id: @distributor_product_list, distributor_product_list: { name: @distributor_product_list.name, product_list_id: @distributor_product_list.product_list_id, sort_order: @distributor_product_list.sort_order }
    assert_redirected_to distributor_product_list_path(assigns(:distributor_product_list))
  end

  test "should destroy distributor_product_list" do
    assert_difference('DistributorProductList.count', -1) do
      delete :destroy, id: @distributor_product_list
    end

    assert_redirected_to distributor_product_lists_path
  end
end
