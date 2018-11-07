class Admin::PlacesController < ApplicationController
  def index
    @places = Place.all
  end

  def edit
    @place = Place.find(params[:id])
    @likes = @place.likes
  end

  def delete
    @place = Place.find(params[:id])
    @place.destroy
    redirect_to admin_places_path
  end
end
