require 'test_helper'

class InteractionMastersControllerTest < ActionController::TestCase
  setup do
    @interaction_master = interaction_masters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:interaction_masters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create interaction_master" do
    assert_difference('InteractionMaster.count') do
      post :create, interaction_master: { campaignplaylistid: @interaction_master.campaignplaylistid, createdon: @interaction_master.createdon, customerid: @interaction_master.customerid, interactioncategoryid: @interaction_master.interactioncategoryid, interactionpriorityid: @interaction_master.interactionpriorityid, interactionstatusid: @interaction_master.interactionstatusid, notes: @interaction_master.notes, orderid: @interaction_master.orderid, productvariantid: @interaction_master.productvariantid, resolveby: @interaction_master.resolveby }
    end

    assert_redirected_to interaction_master_path(assigns(:interaction_master))
  end

  test "should show interaction_master" do
    get :show, id: @interaction_master
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @interaction_master
    assert_response :success
  end

  test "should update interaction_master" do
    patch :update, id: @interaction_master, interaction_master: { campaignplaylistid: @interaction_master.campaignplaylistid, createdon: @interaction_master.createdon, customerid: @interaction_master.customerid, interactioncategoryid: @interaction_master.interactioncategoryid, interactionpriorityid: @interaction_master.interactionpriorityid, interactionstatusid: @interaction_master.interactionstatusid, notes: @interaction_master.notes, orderid: @interaction_master.orderid, productvariantid: @interaction_master.productvariantid, resolveby: @interaction_master.resolveby }
    assert_redirected_to interaction_master_path(assigns(:interaction_master))
  end

  test "should destroy interaction_master" do
    assert_difference('InteractionMaster.count', -1) do
      delete :destroy, id: @interaction_master
    end

    assert_redirected_to interaction_masters_path
  end
end
