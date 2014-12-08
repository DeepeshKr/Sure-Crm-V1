require 'test_helper'

class ProductTrainingHeadingsControllerTest < ActionController::TestCase
  setup do
    @product_training_heading = product_training_headings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_training_headings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_training_heading" do
    assert_difference('ProductTrainingHeading.count') do
      post :create, product_training_heading: { name: @product_training_heading.name, sortorder: @product_training_heading.sortorder }
    end

    assert_redirected_to product_training_heading_path(assigns(:product_training_heading))
  end

  test "should show product_training_heading" do
    get :show, id: @product_training_heading
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product_training_heading
    assert_response :success
  end

  test "should update product_training_heading" do
    patch :update, id: @product_training_heading, product_training_heading: { name: @product_training_heading.name, sortorder: @product_training_heading.sortorder }
    assert_redirected_to product_training_heading_path(assigns(:product_training_heading))
  end

  test "should destroy product_training_heading" do
    assert_difference('ProductTrainingHeading.count', -1) do
      delete :destroy, id: @product_training_heading
    end

    assert_redirected_to product_training_headings_path
  end
end
