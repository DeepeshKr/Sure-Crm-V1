require 'test_helper'

class ProductMasterImagesControllerTest < ActionController::TestCase
  setup do
    @product_master_image = product_master_images(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_master_images)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_master_image" do
    assert_difference('ProductMasterImage.count') do
      post :create, product_master_image: { barcode: @product_master_image.barcode, description: @product_master_image.description, name: @product_master_image.name, prod: @product_master_image.prod, product_list_id: @product_master_image.product_list_id, product_master_id: @product_master_image.product_master_id, product_variant_id: @product_master_image.product_variant_id, sort_order: @product_master_image.sort_order }
    end

    assert_redirected_to product_master_image_path(assigns(:product_master_image))
  end

  test "should show product_master_image" do
    get :show, id: @product_master_image
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product_master_image
    assert_response :success
  end

  test "should update product_master_image" do
    patch :update, id: @product_master_image, product_master_image: { barcode: @product_master_image.barcode, description: @product_master_image.description, name: @product_master_image.name, prod: @product_master_image.prod, product_list_id: @product_master_image.product_list_id, product_master_id: @product_master_image.product_master_id, product_variant_id: @product_master_image.product_variant_id, sort_order: @product_master_image.sort_order }
    assert_redirected_to product_master_image_path(assigns(:product_master_image))
  end

  test "should destroy product_master_image" do
    assert_difference('ProductMasterImage.count', -1) do
      delete :destroy, id: @product_master_image
    end

    assert_redirected_to product_master_images_path
  end
end
