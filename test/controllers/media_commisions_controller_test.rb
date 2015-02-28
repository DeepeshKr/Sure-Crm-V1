require 'test_helper'

class MediaCommisionsControllerTest < ActionController::TestCase
  setup do
    @media_commision = media_commisions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:media_commisions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create media_commision" do
    assert_difference('MediaCommision.count') do
      post :create, media_commision: { description: @media_commision.description, name: @media_commision.name }
    end

    assert_redirected_to media_commision_path(assigns(:media_commision))
  end

  test "should show media_commision" do
    get :show, id: @media_commision
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @media_commision
    assert_response :success
  end

  test "should update media_commision" do
    patch :update, id: @media_commision, media_commision: { description: @media_commision.description, name: @media_commision.name }
    assert_redirected_to media_commision_path(assigns(:media_commision))
  end

  test "should destroy media_commision" do
    assert_difference('MediaCommision.count', -1) do
      delete :destroy, id: @media_commision
    end

    assert_redirected_to media_commisions_path
  end
end
