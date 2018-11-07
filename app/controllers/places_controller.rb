class PlacesController < ApplicationController

  def index
    if params[:search].present?
      @places = Place.perform_search(params[:search])
    else
      @places = Place.all
    end
    @place = Place.new
  end

  def show
    @place = Place.find(params[:id])
    @likes = @place.likes
    @users = @place.users
    @locations = @users.map(&:locations).flatten
    @cities = @locations.map(&:city)
    @states = @locations.map(&:state)
    @countries = @locations.map(&:country)
  end

  def update
  end

  def edit
  end

  def new
    @place = Place.new
  end

  def create
    #before_action :authenticate_user!
    Place.find_or_create_by(
      name: params[:place][:name],
      address: params[:place][:address],
      phone_number: params[:place][:phone_number],
      category: params[:place][:category]
      )
    redirect_to places_path
  end
end
