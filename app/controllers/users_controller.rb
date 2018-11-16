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
    @user.update_attributes(user_params)

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

  def destroy
    @user = current_user
    @user.destroy
    flash[:success] = "User deleted"
    redirect_to places_path
  end

private 
  def user_params
    params
      .require(:user).permit(:name, locations_attributes: [:city, :state, :country])
  end
end
