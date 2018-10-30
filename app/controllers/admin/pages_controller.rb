class Admin::PagesController < ApplicationController
  before_action :authenticate_user!
  if current_user.admin?

  def index
    @pages = Pages.all
  end

  def edit
  end

  def update
  end

  def delete
  end

  def show
  end
end
