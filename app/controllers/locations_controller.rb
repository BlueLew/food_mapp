class LocationsController < ApplicationController
  def index
    @user = current_user
    @locations = @user.locations
  end

  def show; end

  def new
    @location = Location.new
    # @user = current_user
    # @locations = @user.locations
    # @locations.create(
    #   city: params[:city],
    #   state: params[:state],
    #   country: params[:country],
    #   )
    # redirect_to locations_path
  end

  def create
    @user = current_user
    @locations = @user.locations
    Location.find_or_create_by(
      city: params[:location][:city],
      state: params[:location][:state],
      country: params[:location][:country]
    )
    redirect_to locations_path
  end
end
