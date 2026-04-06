class Admin::VenuesController < Admin::BaseController
  before_action :set_venue, only: %i[show edit update destroy]

  def index
    @query = params[:query].to_s.squish
    @venues = Venue.with_attached_photo.order(:name)
    @venues = @venues.search_for(@query) if @query.present?
  end

  def show
    @city_breakdown = @venue.likes_by(:city)
  end

  def new
    @venue = Venue.new
  end

  def edit
  end

  def create
    @venue = Venue.new(venue_params)

    if @venue.save
      redirect_to admin_venue_path(@venue), notice: "Venue created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @venue.update(venue_params)
      redirect_to admin_venue_path(@venue), notice: "Venue updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @venue.destroy!
    redirect_to admin_venues_path, notice: "Venue deleted.", status: :see_other
  end

  private
    def set_venue
      @venue = Venue.find(params.expect(:id))
    end

    def venue_params
      params.expect(venue: [ :name, :address, :category, :phone, :website, :latitude, :longitude, :photo ])
    end
end
