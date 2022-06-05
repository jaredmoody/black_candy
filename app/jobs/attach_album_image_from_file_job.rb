# frozen_string_literal: true

class AttachAlbumImageFromFileJob < ApplicationJob
  queue_as :default

  def perform(album, file_path)
    file_image = MediaFile.image(file_path)

    if album && file_image.present?
      album.image = CarrierWaveStringIO.new("cover.#{file_image[:format]}", file_image[:data])
      album.save
    elsif album.need_attach_from_discogs?
      AttachAlbumImageFromDiscogsJob.perform_later(album)
    end
  end
end
