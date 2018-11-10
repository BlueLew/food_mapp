class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  
    def index
      @users = User.all
    end

    def show
      @user = User.find(params[:id])
      @likes = @user.likes
      @places = @user.places
      @locations = @user.locations
    end

    def update
      @post = Place.find(params[:id])
      @place.update(place_params)
      if @place.save
        redirect_to admin_places_path
      else
        render :edit
      end
    end

    def delete
      @user = User.find(params[:id])
      @user.destroy
      flash[:success] = "User deleted"
      redirect_to admin_users_path
    end

    def destroy
      @user = User.find(params[:id])
      @user.destroy
      flash[:success] = "User deleted"
      redirect_to admin_users_path
    end

private
  def authenticate_admin!
    authenticate_user!
    redirect_to root_path, status: :forbidden unless current_user.admin?
  end

end
