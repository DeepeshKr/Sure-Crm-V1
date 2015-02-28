require 'test_helper'

class CampaignPlaylistsControllerTest < ActionController::TestCase
  setup do
    @campaign_playlist = campaign_playlists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:campaign_playlists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create campaign_playlist" do
    assert_difference('CampaignPlaylist.count') do
      post :create, campaign_playlist: { campaignid: @campaign_playlist.campaignid, description: @campaign_playlist.description, endtime: @campaign_playlist.endtime, filename: @campaign_playlist.filename, name: @campaign_playlist.name, productvariantid: @campaign_playlist.productvariantid, starttime: @campaign_playlist.starttime }
    end

    assert_redirected_to campaign_playlist_path(assigns(:campaign_playlist))
  end

  test "should show campaign_playlist" do
    get :show, id: @campaign_playlist
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @campaign_playlist
    assert_response :success
  end

  test "should update campaign_playlist" do
    patch :update, id: @campaign_playlist, campaign_playlist: { campaignid: @campaign_playlist.campaignid, description: @campaign_playlist.description, endtime: @campaign_playlist.endtime, filename: @campaign_playlist.filename, name: @campaign_playlist.name, productvariantid: @campaign_playlist.productvariantid, starttime: @campaign_playlist.starttime }
    assert_redirected_to campaign_playlist_path(assigns(:campaign_playlist))
  end

  test "should destroy campaign_playlist" do
    assert_difference('CampaignPlaylist.count', -1) do
      delete :destroy, id: @campaign_playlist
    end

    assert_redirected_to campaign_playlists_path
  end
end
