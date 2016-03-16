require 'test_helper'

class ListOfServersControllerTest < ActionController::TestCase
  setup do
    @list_of_server = list_of_servers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:list_of_servers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create list_of_server" do
    assert_difference('ListOfServer.count') do
      post :create, list_of_server: { active_since: @list_of_server.active_since, current_status: @list_of_server.current_status, description: @list_of_server.description, external_ip: @list_of_server.external_ip, internal_ip: @list_of_server.internal_ip, name: @list_of_server.name, vpn_ip: @list_of_server.vpn_ip }
    end

    assert_redirected_to list_of_server_path(assigns(:list_of_server))
  end

  test "should show list_of_server" do
    get :show, id: @list_of_server
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @list_of_server
    assert_response :success
  end

  test "should update list_of_server" do
    patch :update, id: @list_of_server, list_of_server: { active_since: @list_of_server.active_since, current_status: @list_of_server.current_status, description: @list_of_server.description, external_ip: @list_of_server.external_ip, internal_ip: @list_of_server.internal_ip, name: @list_of_server.name, vpn_ip: @list_of_server.vpn_ip }
    assert_redirected_to list_of_server_path(assigns(:list_of_server))
  end

  test "should destroy list_of_server" do
    assert_difference('ListOfServer.count', -1) do
      delete :destroy, id: @list_of_server
    end

    assert_redirected_to list_of_servers_path
  end
end
