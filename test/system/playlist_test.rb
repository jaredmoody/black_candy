# frozen_string_literal: true

require "application_system_test_case"

class PlaylistSystemTest < ApplicationSystemTestCase
  setup do
    Setting.update(media_path: Rails.root.join("test/fixtures/files"))
    login_as users(:admin)
    click_on "Playlists"
    click_on "playlist1"
  end

  test "show playlist songs" do
    playlists(:playlist1).songs.each do |song|
      assert_selector(:test_id, "playlist_song_name", text: song.name)
    end
  end

  test "play all songs in playlist" do
    find(:test_id, "playlist_menu").click
    click_on "Play all"

    # assert current playlist have all songs in playlist
    assert_selector(:test_id, "current_playlist", visible: true)
    playlists(:playlist1).songs.each do |song|
      assert_selector(:test_id, "playlist_song_name", text: song.name)
    end

    # assert play the first song in playlist
    assert_selector(:test_id, "player_song_name", text: Song.first.name)
  end

  test "clear playlist songs" do
    find(:test_id, "playlist_menu").click
    click_on "Clear"

    assert_selector(:test_id, "playlist_song", count: 0)
  end

  test "delete playlist" do
    find(:test_id, "playlist_menu").click
    click_on "Delete"

    assert_selector(:test_id, "playlist", count: 0)
  end

  test "rename playlist" do
    find(:test_id, "playlist_menu").click
    click_on "Rename"

    fill_in "playlist_name_input", with: "renamed_playlist"
    # blur the input
    find("body").click

    assert_selector(:test_id, "playlist_name", text: "renamed_playlist")
  end

  test "delete song in playlist" do
    playlist_songs_count = playlists(:playlist1).songs.count

    first(:test_id, "playlist_song_menu").click
    click_on "Delete"

    assert_selector(:test_id, "playlist_song", count: playlist_songs_count - 1)
  end

  test "reorder song in playlist" do
    first_playlist_song_name = playlists(:playlist1).songs.first.name
    source_element = first(:test_id, "playlist_song_sortable_handle")
    target_element = all(:test_id, "playlist_song_sortable_handle").last

    source_element.drag_to(target_element)

    assert_equal first_playlist_song_name, all(:test_id, "playlist_song_name").last.text
  end

  test "play song in playlist" do
    first(:test_id, "playlist_song").click

    assert_selector(:test_id, "player_header", visible: true)
    assert_selector(:test_id, "player_song_name", text: playlists(:playlist1).songs.first.name)
  end

  test "add song to another playlist" do
    Playlist.create(name: "test-playlist", user_id: users(:admin).id)

    first(:test_id, "playlist_song_menu").click
    click_on "Add to playlist"
    first(:test_id, "dialog_playlist").click

    assert_selector(:test_id, "playlist_name", text: "test-playlist")
    assert_equal playlists(:playlist1).songs.first.name, first(:test_id, "playlist_song_name").text
  end
end
