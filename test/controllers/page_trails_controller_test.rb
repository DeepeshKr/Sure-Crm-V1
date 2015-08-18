require 'test_helper'

class PageTrailsControllerTest < ActionController::TestCase
  setup do
    @page_trail = page_trails(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:page_trails)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create page_trail" do
    assert_difference('PageTrail.count') do
      post :create, page_trail: { duration_secs: @page_trail.duration_secs, employee_id: @page_trail.employee_id, name: @page_trail.name, order_id: @page_trail.order_id, page_id: @page_trail.page_id, url: @page_trail.url }
    end

    assert_redirected_to page_trail_path(assigns(:page_trail))
  end

  test "should show page_trail" do
    get :show, id: @page_trail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @page_trail
    assert_response :success
  end

  test "should update page_trail" do
    patch :update, id: @page_trail, page_trail: { duration_secs: @page_trail.duration_secs, employee_id: @page_trail.employee_id, name: @page_trail.name, order_id: @page_trail.order_id, page_id: @page_trail.page_id, url: @page_trail.url }
    assert_redirected_to page_trail_path(assigns(:page_trail))
  end

  test "should destroy page_trail" do
    assert_difference('PageTrail.count', -1) do
      delete :destroy, id: @page_trail
    end

    assert_redirected_to page_trails_path
  end
end
