class LikesController < ApplicationController
  before_action :set_venue

  def create
    current_user.likes.find_or_create_by!(venue: @venue)
    respond_to_like
  end

  def destroy
    current_user.likes.find_by!(venue: @venue).destroy!
    respond_to_like
  end

  private
    def set_venue
      @venue = Venue.find(params.expect(:venue_id))
    end

    def respond_to_like
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to venue_path(@venue), notice: "Your preference has been updated." }
      end
    end
end
