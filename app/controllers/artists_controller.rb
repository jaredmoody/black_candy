# frozen_string_literal: true

class ArtistsController < ApplicationController
  include Pagy::Backend

  layout "dialog", only: :edit

  before_action :require_admin, only: [:edit, :update]
  before_action :find_artist, except: [:index]

  def index
    records = Artist.order(:name)
    @pagy, @artists = pagy(records)
  end

  def show
    @albums = @artist.albums.load_async
    @appears_on_albums = @artist.appears_on_albums.load_async

    AttachArtistImageFromDiscogsJob.perform_later(@artist) if @artist.need_attach_from_discogs?
  end

  def edit
  end

  def update
    if @artist.update(artist_params)
      flash[:success] = t("success.update")
    else
      flash_errors_message(@artist)
    end

    redirect_to @artist
  end

  private

  def artist_params
    params.require(:artist).permit(:image)
  end

  def find_artist
    @artist = Artist.find(params[:id])
  end
end
