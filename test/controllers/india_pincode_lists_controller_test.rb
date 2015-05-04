require 'test_helper'

class IndiaPincodeListsControllerTest < ActionController::TestCase
  setup do
    @india_pincode_list = india_pincode_lists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:india_pincode_lists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create india_pincode_list" do
    assert_difference('IndiaPincodeList.count') do
      post :create, india_pincode_list: { circlename: @india_pincode_list.circlename, deliverystatus: @india_pincode_list.deliverystatus, districtname: @india_pincode_list.districtname, divisionname: @india_pincode_list.divisionname, officename: @india_pincode_list.officename, pincode: @india_pincode_list.pincode, regionname: @india_pincode_list.regionname, statename: @india_pincode_list.statename, taluk: @india_pincode_list.taluk }
    end

    assert_redirected_to india_pincode_list_path(assigns(:india_pincode_list))
  end

  test "should show india_pincode_list" do
    get :show, id: @india_pincode_list
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @india_pincode_list
    assert_response :success
  end

  test "should update india_pincode_list" do
    patch :update, id: @india_pincode_list, india_pincode_list: { circlename: @india_pincode_list.circlename, deliverystatus: @india_pincode_list.deliverystatus, districtname: @india_pincode_list.districtname, divisionname: @india_pincode_list.divisionname, officename: @india_pincode_list.officename, pincode: @india_pincode_list.pincode, regionname: @india_pincode_list.regionname, statename: @india_pincode_list.statename, taluk: @india_pincode_list.taluk }
    assert_redirected_to india_pincode_list_path(assigns(:india_pincode_list))
  end

  test "should destroy india_pincode_list" do
    assert_difference('IndiaPincodeList.count', -1) do
      delete :destroy, id: @india_pincode_list
    end

    assert_redirected_to india_pincode_lists_path
  end
end
