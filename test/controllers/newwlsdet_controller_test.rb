require 'test_helper'

class NewwlsdetControllerTest < ActionController::TestCase
  test "should get list" do
    get :list
    assert_response :success
  end

  test "should get search" do
    get :search
    assert_response :success
  end

  test "should get details" do
    get :details
    assert_response :success
  end

end
