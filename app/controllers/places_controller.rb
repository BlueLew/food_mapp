class PlacesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @places = Places.all
  end

  def show
    @place = Place.find(params[:id])
  end

  def update
  end

  def edit
  end

  def create
    Place.create(name: params[:place][:name])
    redirect_to places_index_path
  end
end
