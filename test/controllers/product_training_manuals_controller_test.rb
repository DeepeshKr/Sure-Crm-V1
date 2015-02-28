require 'test_helper'

class ProductTrainingManualsControllerTest < ActionController::TestCase
  setup do
    @product_training_manual = product_training_manuals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_training_manuals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_training_manual" do
    assert_difference('ProductTrainingManual.count') do
      post :create, product_training_manual: { description: @product_training_manual.description, name: @product_training_manual.name, productid: @product_training_manual.productid, quicknotes: @product_training_manual.quicknotes }
    end

    assert_redirected_to product_training_manual_path(assigns(:product_training_manual))
  end

  test "should show product_training_manual" do
    get :show, id: @product_training_manual
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product_training_manual
    assert_response :success
  end

  test "should update product_training_manual" do
    patch :update, id: @product_training_manual, product_training_manual: { description: @product_training_manual.description, name: @product_training_manual.name, productid: @product_training_manual.productid, quicknotes: @product_training_manual.quicknotes }
    assert_redirected_to product_training_manual_path(assigns(:product_training_manual))
  end

  test "should destroy product_training_manual" do
    assert_difference('ProductTrainingManual.count', -1) do
      delete :destroy, id: @product_training_manual
    end

    assert_redirected_to product_training_manuals_path
  end
end
