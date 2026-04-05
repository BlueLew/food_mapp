class LikesController < ApplicationController
  before_action :set_venue

  def create
    current_user.likes.find_or_create_by!(venue: @venue)
    @venue.reload
    respond_to_like
  end

  def destroy
    current_user.likes.find_by!(venue: @venue).destroy!
    @venue.reload
    respond_to_like
  end

  private
    def set_venue
      @venue = Venue.find(params.expect(:venue_id))
    end

    def respond_to_like
      @query = params[:query].to_s.squish
      @venues = Venue.search_for(@query).with_attached_photo.includes(:likes)

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to venue_path(@venue), notice: "Your preference has been updated." }
      end
    end
end
