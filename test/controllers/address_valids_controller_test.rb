require 'test_helper'

class AddressValidsControllerTest < ActionController::TestCase
  setup do
    @address_valid = address_valids(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:address_valids)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create address_valid" do
    assert_difference('AddressValid.count') do
      post :create, address_valid: { name: @address_valid.name }
    end

    assert_redirected_to address_valid_path(assigns(:address_valid))
  end

  test "should show address_valid" do
    get :show, id: @address_valid
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @address_valid
    assert_response :success
  end

  test "should update address_valid" do
    patch :update, id: @address_valid, address_valid: { name: @address_valid.name }
    assert_redirected_to address_valid_path(assigns(:address_valid))
  end

  test "should destroy address_valid" do
    assert_difference('AddressValid.count', -1) do
      delete :destroy, id: @address_valid
    end

    assert_redirected_to address_valids_path
  end
end
