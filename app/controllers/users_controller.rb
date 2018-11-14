class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @user = current_user
    @likes = @user.likes
    @locations = @user.locations
    @places = @user.places
  end

  def edit
    @user = current_user
    @likes = @user.likes
    @locations = @user.locations
  end

  def update
    @user = current_user
    @locations = @user.locations
    @user.name = params[:user][:name]
    @user.avatar.attach(params[:user][:avatar])
    @locations = params[:locations][:city], 
      [:locations][:state], [:locations][:country]

    if current_user.save
      redirect_to user_path
    else
      render :edit
    end
  end

  def delete
    @user = current_user
    @user.destroy
    flash[:success] = "User deleted"
    redirect_to places_path
  end

  def destory
    @user = current_user
    @user.destroy
    flash[:success] = "User deleted"
    redirect_to places_path
  end

private 
  def user_params
    params
      .require(:user)
      .permit(:city, locations_attributes: Location.attribute_cities.map(&:to_sym).push(:_destroy))
      .permit(:state, locations_attributes: Location.attribute_states.map(&:to_sym).push(:_destroy))
      .permit(:country, locations_attributes: Location.attribute_countries.map(&:to_sym).push(:_destroy))
  end
end
