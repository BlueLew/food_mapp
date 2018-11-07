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
    #@locations = @users.map(&:locations).flatten
    @likes_by_cities = @place.locations.group_by(&:city).map { 
      |city, location| "#{city} = #{location.count} likes"}
    @likes_by_states = @place.locations.group_by(&:state).map { 
      |state, location| "#{state} = #{location.count} likes"}
    @likes_by_countries = @place.locations.group_by(&:country).map { 
      |country, location| "#{country} = #{location.count} likes"}
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
