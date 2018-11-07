class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @user = current_user
  end

  def edit
    @user = User.find(params[:id])
    @locations = @user.locations
  end

  def update
    current_user.name = params[:user][:name]
    current_user.avatar.attach(params[:user][:avatar])
    #current_user.locations = params[:locations][:city], 
                              #[:locations][:state],
                              #[:locations][:country]

    if current_user.save
      redirect_to user_path
    else
      render :edit
    end
  end

  def delete
    @user = current_user
  end
end
