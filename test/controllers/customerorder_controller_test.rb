require 'test_helper'

class CustomerorderControllerTest < ActionController::TestCase
  test "should get products" do
    get :products
    assert_response :success
  end

  test "should get address" do
    get :address
    assert_response :success
  end

  test "should get payment" do
    get :payment
    assert_response :success
  end

  test "should get channel" do
    get :channel
    assert_response :success
  end

  test "should get review" do
    get :review
    assert_response :success
  end

  test "should get summary" do
    get :summary
    assert_response :success
  end

end
