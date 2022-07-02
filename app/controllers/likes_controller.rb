class LikesController < ApplicationController
  before_action :authenticate_user!, :find_place

  def index
    @place = Place.find(params[:id])
    @likes = @place.likes
    @likes_by_cities = likes_by(:city)
    @likes_by_states = likes_by(:state)
    @likes_by_countries = likes_by(:country)
  end

  def create
    if already_liked?
      flash[:notice] = "You can't like this restaurant more than once"
    else
      @place.likes.create(user_id: current_user.id)
    end
    redirect_to place_path(@place)
  end

  private

  def find_place
    @place = Place.find(params[:place_id])
  end

  def already_liked?
    Like.where(user_id: current_user.id, place_id:
    params[:place_id]).exists?
  end
end
