require 'test_helper'

class SalesPpoDefaultsControllerTest < ActionController::TestCase
  setup do
    @sales_ppo_default = sales_ppo_defaults(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sales_ppo_defaults)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sales_ppo_default" do
    assert_difference('SalesPpoDefault.count') do
      post :create, sales_ppo_default: { description: @sales_ppo_default.description, name: @sales_ppo_default.name, value: @sales_ppo_default.value }
    end

    assert_redirected_to sales_ppo_default_path(assigns(:sales_ppo_default))
  end

  test "should show sales_ppo_default" do
    get :show, id: @sales_ppo_default
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sales_ppo_default
    assert_response :success
  end

  test "should update sales_ppo_default" do
    patch :update, id: @sales_ppo_default, sales_ppo_default: { description: @sales_ppo_default.description, name: @sales_ppo_default.name, value: @sales_ppo_default.value }
    assert_redirected_to sales_ppo_default_path(assigns(:sales_ppo_default))
  end

  test "should destroy sales_ppo_default" do
    assert_difference('SalesPpoDefault.count', -1) do
      delete :destroy, id: @sales_ppo_default
    end

    assert_redirected_to sales_ppo_defaults_path
  end
end
