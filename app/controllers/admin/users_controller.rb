class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: %i[show edit update destroy]

  def index
    @query = params[:query].to_s.squish
    @users = User.includes(:residences, :likes).order(:name, :email_address)
    @users = @users.where("name ILIKE :query OR email_address ILIKE :query", query: "%#{@query}%") if @query.present?
  end

  def show
    @residences = @user.residences.ordered
    @liked_venues = @user.liked_venues.order(:name)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "User updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @user.destroy!
    redirect_to admin_users_path, notice: "User deleted.", status: :see_other
  end

  private
    def set_user
      @user = User.find(params.expect(:id))
    end

    def user_params
      params.expect(user: [ :name, :email_address, :role, :avatar ])
    end
end
