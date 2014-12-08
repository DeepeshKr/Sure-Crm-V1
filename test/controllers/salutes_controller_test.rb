require 'test_helper'

class SalutesControllerTest < ActionController::TestCase
  setup do
    @salute = salutes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:salutes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create salute" do
    assert_difference('Salute.count') do
      post :create, salute: { name: @salute.name }
    end

    assert_redirected_to salute_path(assigns(:salute))
  end

  test "should show salute" do
    get :show, id: @salute
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @salute
    assert_response :success
  end

  test "should update salute" do
    patch :update, id: @salute, salute: { name: @salute.name }
    assert_redirected_to salute_path(assigns(:salute))
  end

  test "should destroy salute" do
    assert_difference('Salute.count', -1) do
      delete :destroy, id: @salute
    end

    assert_redirected_to salutes_path
  end
end
