class LikesController < ApplicationController
  before_action :authenticate_user!, :find_place

  def create
    if already_liked?
      flash[:notice] = "You can't like more than once"
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
