class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  #if current_user(:admin,true)
  
    def index
      @users = User.all
    end

    def edit
      @user = User.find(params[:id])
      @likes = @user.likes
    end

    def update
    end

    def delete
    end
  #end
end
