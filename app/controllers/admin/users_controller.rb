class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  if current_user.admin?
  
  def index
    @users = Users.all
  end

  def edit
  end

  def update
  end

  def delete
  end
end
