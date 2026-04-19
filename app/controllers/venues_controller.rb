class VenuesController < ApplicationController
  allow_unauthenticated_access only: %i[index show]
  before_action :set_venue, only: :show
  before_action :resume_session, only: %i[index show]

  def index
    @query = params[:query].to_s.squish
    @venues = Venue.search_for(@query).with_attached_photo.includes(:likes)
    @liked_venue_ids = current_user ? current_user.likes.pluck(:venue_id) : []
  end

  def show
    @city_breakdown = @venue.likes_by(:city)
    @state_breakdown = @venue.likes_by(:state)
    @country_breakdown = @venue.likes_by(:country)
    @liked = current_user&.likes&.exists?(venue: @venue) || false
    @venue_markers = map_markers_for([ @venue ])
    @residence_markers = map_markers_for(@venue.liked_residences)
  end

  private
    def set_venue
      @venue = Venue.find(params.expect(:id))
    end

    def map_markers_for(records)
      records.filter_map do |record|
        next unless record.latitude.present? && record.longitude.present?

        {
          lat: record.latitude,
          lng: record.longitude,
          title: record.try(:name) || record.try(:display_name) || record.try(:full_address),
          info: record.try(:address) || record.try(:full_address) || record.try(:email_address)
        }
      end
    end
end
