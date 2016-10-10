require 'test_helper'

class CustDetailsTracksControllerTest < ActionController::TestCase
  setup do
    @cust_details_track = cust_details_tracks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cust_details_tracks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cust_details_track" do
    assert_difference('CustDetailsTrack.count') do
      post :create, cust_details_track: { alt_mobile: @cust_details_track.alt_mobile, current_status: @cust_details_track.current_status, custdetails: @cust_details_track.custdetails, dealtran: @cust_details_track.dealtran, ext_ref_id: @cust_details_track.ext_ref_id, last_call_back_on: @cust_details_track.last_call_back_on, mobile: @cust_details_track.mobile, no_of_attempts: @cust_details_track.no_of_attempts, order_date: @cust_details_track.order_date, order_ref_id: @cust_details_track.order_ref_id, products: @cust_details_track.products, vpp: @cust_details_track.vpp }
    end

    assert_redirected_to cust_details_track_path(assigns(:cust_details_track))
  end

  test "should show cust_details_track" do
    get :show, id: @cust_details_track
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cust_details_track
    assert_response :success
  end

  test "should update cust_details_track" do
    patch :update, id: @cust_details_track, cust_details_track: { alt_mobile: @cust_details_track.alt_mobile, current_status: @cust_details_track.current_status, custdetails: @cust_details_track.custdetails, dealtran: @cust_details_track.dealtran, ext_ref_id: @cust_details_track.ext_ref_id, last_call_back_on: @cust_details_track.last_call_back_on, mobile: @cust_details_track.mobile, no_of_attempts: @cust_details_track.no_of_attempts, order_date: @cust_details_track.order_date, order_ref_id: @cust_details_track.order_ref_id, products: @cust_details_track.products, vpp: @cust_details_track.vpp }
    assert_redirected_to cust_details_track_path(assigns(:cust_details_track))
  end

  test "should destroy cust_details_track" do
    assert_difference('CustDetailsTrack.count', -1) do
      delete :destroy, id: @cust_details_track
    end

    assert_redirected_to cust_details_tracks_path
  end
end
