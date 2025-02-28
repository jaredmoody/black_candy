# frozen_string_literal: true

require "test_helper"

class TranscodedStreamControllerTest < ActionDispatch::IntegrationTest
  setup do
    Setting.update(media_path: Rails.root.join("test/fixtures/files"))

    cache_directory = "#{Stream::TRANSCODE_CACHE_DIRECTORY}/#{songs(:flac_sample).id}"
    if Dir.exist?(cache_directory)
      FileUtils.remove_dir(cache_directory)
    end
  end

  test "should get new stream for transcode format" do
    assert_login_access(url: new_transcoded_stream_url(song_id: songs(:flac_sample).id)) do
      assert_response :success
    end
  end

  test "should get transcoded data" do
    assert_login_access(url: new_transcoded_stream_url(song_id: songs(:flac_sample).id)) do
      create_tmp_file(format: "mp3") do |tmp_file_path|
        File.write(tmp_file_path, response.body)

        assert_equal 128, audio_bitrate(tmp_file_path)
      end
    end
  end

  test "should write cache when don't find cache" do
    stream = Stream.new(songs(:flac_sample))
    assert_not File.exist? stream.transcode_cache_file_path

    assert_login_access(url: new_transcoded_stream_url(song_id: songs(:flac_sample).id)) do
      assert_response :success
      assert File.exist? stream.transcode_cache_file_path
    end
  end

  test "should redirect to cache transcoded stream path when found cache" do
    assert_login_access(url: new_transcoded_stream_url(song_id: songs(:flac_sample).id)) do
      assert_response :success
    end

    assert_login_access(url: new_transcoded_stream_url(song_id: songs(:flac_sample).id)) do
      assert_redirected_to new_cached_transcoded_stream_url(song_id: songs(:flac_sample).id)
    end
  end

  test "should regenerate new cache when cache is invalid" do
    stream = Stream.new(songs(:flac_sample))

    assert_login_access(url: new_transcoded_stream_url(song_id: songs(:flac_sample).id)) do
      assert_response :success
    end

    original_cache_file_mtime = File.mtime(stream.transcode_cache_file_path)

    # Make the duration of the song different from the duration of the cache,
    # so that the cache will be treated as invalid
    songs(:flac_sample).update(duration: 12.0)

    assert_login_access(url: new_transcoded_stream_url(song_id: songs(:flac_sample).id)) do
      assert_response :success
    end

    assert_not_equal original_cache_file_mtime, File.mtime(stream.transcode_cache_file_path)
  end

  test "should set correct content type header" do
    assert_login_access(url: new_transcoded_stream_url(song_id: songs(:flac_sample).id)) do
      assert_equal "audio/mpeg", @response.get_header("Content-Type")
    end
  end
end
