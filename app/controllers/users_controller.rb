class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @user = current_user
    @likes = @user.likes
    @locations = @user.locations
    @likes_by_places = @user.places.group_by(&:name).map #{ 
      #|key, value| "#{key} - #{value.count} likes"}
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
end
