class ProfilesController < ApplicationController
  def show
    @user = current_user
    @residences = @user.residences.ordered
    @liked_venues = @user.liked_venues.with_attached_photo.distinct.order(:name)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(profile_params)
      redirect_to profile_path, notice: "Profile updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  private
    def profile_params
      params.expect(user: [ :name, :email_address, :avatar ])
    end
end
