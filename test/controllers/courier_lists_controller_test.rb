require 'test_helper'

class CourierListsControllerTest < ActionController::TestCase
  setup do
    @courier_list = courier_lists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:courier_lists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create courier_list" do
    assert_difference('CourierList.count') do
      post :create, courier_list: { active: @courier_list.active, contact_details: @courier_list.contact_details, description: @courier_list.description, helpline: @courier_list.helpline, name: @courier_list.name, ref_code: @courier_list.ref_code, sort_order: @courier_list.sort_order, tracking_url: @courier_list.tracking_url }
    end

    assert_redirected_to courier_list_path(assigns(:courier_list))
  end

  test "should show courier_list" do
    get :show, id: @courier_list
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @courier_list
    assert_response :success
  end

  test "should update courier_list" do
    patch :update, id: @courier_list, courier_list: { active: @courier_list.active, contact_details: @courier_list.contact_details, description: @courier_list.description, helpline: @courier_list.helpline, name: @courier_list.name, ref_code: @courier_list.ref_code, sort_order: @courier_list.sort_order, tracking_url: @courier_list.tracking_url }
    assert_redirected_to courier_list_path(assigns(:courier_list))
  end

  test "should destroy courier_list" do
    assert_difference('CourierList.count', -1) do
      delete :destroy, id: @courier_list
    end

    assert_redirected_to courier_lists_path
  end
end
