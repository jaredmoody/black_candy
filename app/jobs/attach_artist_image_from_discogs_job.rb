# frozen_string_literal: true

class AttachArtistImageFromDiscogsJob < ApplicationJob
  queue_as :default

  def perform(artist)
    image_url = DiscogsApi.artist_image(artist)

    return if image_url.blank?

    artist.remote_image_url = image_url
    artist.save
  end
end
