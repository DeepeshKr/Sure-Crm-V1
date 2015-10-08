require 'test_helper'

class DistributorPincodeListsControllerTest < ActionController::TestCase
  setup do
    @distributor_pincode_list = distributor_pincode_lists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:distributor_pincode_lists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create distributor_pincode_list" do
    assert_difference('DistributorPincodeList.count') do
      post :create, distributor_pincode_list: { name: @distributor_pincode_list.name, pincode: @distributor_pincode_list.pincode, sort_order: @distributor_pincode_list.sort_order }
    end

    assert_redirected_to distributor_pincode_list_path(assigns(:distributor_pincode_list))
  end

  test "should show distributor_pincode_list" do
    get :show, id: @distributor_pincode_list
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @distributor_pincode_list
    assert_response :success
  end

  test "should update distributor_pincode_list" do
    patch :update, id: @distributor_pincode_list, distributor_pincode_list: { name: @distributor_pincode_list.name, pincode: @distributor_pincode_list.pincode, sort_order: @distributor_pincode_list.sort_order }
    assert_redirected_to distributor_pincode_list_path(assigns(:distributor_pincode_list))
  end

  test "should destroy distributor_pincode_list" do
    assert_difference('DistributorPincodeList.count', -1) do
      delete :destroy, id: @distributor_pincode_list
    end

    assert_redirected_to distributor_pincode_lists_path
  end
end
