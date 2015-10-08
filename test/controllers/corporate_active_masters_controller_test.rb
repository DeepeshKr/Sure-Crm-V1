require 'test_helper'

class CorporateActiveMastersControllerTest < ActionController::TestCase
  setup do
    @corporate_active_master = corporate_active_masters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:corporate_active_masters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create corporate_active_master" do
    assert_difference('CorporateActiveMaster.count') do
      post :create, corporate_active_master: { description: @corporate_active_master.description, name: @corporate_active_master.name, sort_order: @corporate_active_master.sort_order }
    end

    assert_redirected_to corporate_active_master_path(assigns(:corporate_active_master))
  end

  test "should show corporate_active_master" do
    get :show, id: @corporate_active_master
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @corporate_active_master
    assert_response :success
  end

  test "should update corporate_active_master" do
    patch :update, id: @corporate_active_master, corporate_active_master: { description: @corporate_active_master.description, name: @corporate_active_master.name, sort_order: @corporate_active_master.sort_order }
    assert_redirected_to corporate_active_master_path(assigns(:corporate_active_master))
  end

  test "should destroy corporate_active_master" do
    assert_difference('CorporateActiveMaster.count', -1) do
      delete :destroy, id: @corporate_active_master
    end

    assert_redirected_to corporate_active_masters_path
  end
end
